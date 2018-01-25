function [G, gG] = generateOperator_fast2(Patch, S, doSolve)
    tic();    
    r = linspace(0, 1, S);
    [X, Y] = meshgrid(r, r);
    
    Sz = S;
    V = findVs(Patch{1}, Sz);
    
    sampleCount = 501;
    %figure; hold all;
    [G1, Gs1, mask1] = fillGrid(Patch{1}, S, Sz, sampleCount, -1, X, Y, V);
    [G2, Gs2, mask2] = fillGrid(Patch{2}, S, Sz, sampleCount, 1, X, Y, V);
    
    mask = mask1 | mask2;
    maskB = mask1 & mask2;
    Gs = Gs1;
    Gs(mask2) = Gs2(mask2);
    Gs(maskB) = max(Gs1(maskB), Gs2(maskB));
    G = min(G1, G2);
    
    if length(Patch) == 3
        [G3, Gs3, mask3] = fillGrid(Patch{3}, S, sampleCount, 1, X, Y, V);
        mask = mask | mask3;
        mask3o = ~mask1 & ~mask2 & mask3;
        Gs(mask3o) = abs(Gs3(mask3o));
        G = min(G, G3);
    end
    
    G(mask) = Gs(mask) .* G(mask) + 0.5;
    G(~mask) = 0;
    
    if doSolve
        G = solve(G, mask, S, Sz);
    else
        G = fillOnes(G, mask, S, Sz);
        if mod(S, 2) == 0
            imid = S/2 + [-1 0 1 2];
        else
            imid = (S+1)/2 + [-2 -1 0 1 2];
        end    
        r1 = r';
        r3 = r1(imid);
        G(1, imid, :) = repmat(r3, 1, Sz);
        G(2, imid, :) = repmat(r3, 1, Sz);
        G(imid, 1, :) = repmat(r3, 1, Sz);
        G(imid, 2, :) = repmat(r3, 1, Sz);
    end

    disp('Gradient computation...');
    % 4. Compute the gradients by finite difference
    gGx = cat(2, G(:, 2:end, :) - G(:, 1:end-1, :), G(:, end, :) - G(:, end-1, :));
    gGy = cat(1, G(2:end, :, :) - G(1:end-1, :, :), G(end, :, :) - G(end-1, :, :));
    gG = cat(4, gGx, gGy) * (S - 1); % Divide by the size of the cells, 1 / (S - 1)
    disp('Gradient computation: Done');
    toc();
end

function G = solve(G, mask, S, Sz)
    % 1. Boundary conditions
    r1 = linspace(0, 1, S)';
    r2 = r1(2:(S-1));
    G(1, :, :) = repmat(r1, 1, Sz); mask(1, :, :) = 1; % Bottom
    G(:, 1, :) = repmat(r1, 1, Sz); mask(:, 1, :) = 1; % Left
    G(S, :, :) = 1; mask(S, :, :) = 1; % Right
    G(:, S, :) = 1; mask(:, S, :) = 1; % Top
    G(2, 2:(S-1), :) = repmat(r2, 1, Sz); mask(2, 2:(S-1), :) = 1; % Bottom 2
    G(2:(S-1), 2, :) = repmat(r2, 1, Sz); mask(2:(S-1), 2, :) = 1; % Left 2
    G(S - 1, 2:(S-1), :) = r2(end); mask(S - 1, 2:(S-1), :) = 1; % Right 2
    G(2:(S-1), S - 1, :) = r2(end); mask(2:(S-1), S - 1, :) = 1; % Top 2
    
    disp('Solver...');
    % 2. Solve the bi-harmonic problem
    for k = 1:Sz
        %G(:,:,k) = solveSlice(G(:,:,k), mask(:,:,k));
        G(:,:,k) = genOp(G(:,:,k), mask(:,:,k));
    end
    disp('Solver: Done');
    
    % 3. Clamping: why do I get values > 1? :(
    G = min(max(G, 0), 1);
end

function V = findVs(Patch, S)
    s = 1000;
    t = linspace(0, 1, S);
    ts = linspace(0, 1, s);
    sp = zeros(s, 3);
    for i = 1:s
        sp(i, :) = Patch.eval(0, ts(i));
    end
    sp = sp(:,3);
    
    V = zeros(S, 1);
    V(1) = 0.0;
    V(end) = 1.0;
    k = 2;
    for i = 1:s-1
        a = sp(i);
        b = sp(i+1);
        c = t(k);
        if c >= a && c <= b
            alpha = (c - a) / (b - a);
            V(k) = (1 - alpha) * ts(i) + alpha * ts(i+1);
            k = k + 1;
        end
    end
end

function [G, Gs, mask] = fillGrid(Patch, S, Sz, sampleCount, Nfactor, X, Y, V)
    G = Inf(S, S, Sz);
    mask = false(S, S, Sz);
    Gs = zeros(S, S, Sz);
    
    for i = 1:Sz
        [G(:,:,i), Gs(:,:,i), mask(:,:,i)] = fillSlice(Patch, S, sampleCount, Nfactor, X, Y, V(i));
    end
end

function [G, Gs, mask] = fillSlice(Patch, S, sampleCount, Nfactor, X, Y, v)
    sp = zeros(sampleCount, 3);
    sv = linspace(0, 1, sampleCount);
    for i = 1:sampleCount
        sp(i, :) = Patch.eval(sv(i), v);
    end
    %sp3 = sp(:,3);
    sp(:,3) = [];
    
    %sn = [sp(2:end, :) - sp(1:end-1, :); sp(end, :) - sp(end-1, :)];
    %sn = [(sp(2:end, :) - sp(1:end-1, :)) * Nfactor; [1 1] / sqrt(2)];
    sn = [sp(2:end, :) - sp(1:end-1, :); sp(end, :) - sp(end-1, :)] * Nfactor;
    sn = [-sn(:,2) sn(:,1)];
    sn = sn ./ sqrt(sum(sn.^2, 2));
    
    
    %scatter3(sp(:,1), sp(:,2), ones(sampleCount, 1) * 0, 1, 'filled');
    %plot3(sp(:,1), sp(:,2), ones(sampleCount, 1) * sp3(1), '.');
    %quiver(sp(1:10:end,1), sp(1:10:end,2), sn(1:10:end,1), sn(1:10:end,2), 1);
    
    neighKernel = [-1 0 1 2];
    %neighKernel = -10:10;
    %neighMat = repmat(neighKernel, length(neighKernel), 1);
    %neighMat = cat(3, neighMat, neighMat');
    
    G = Inf(S, S);
    mask = false(S, S);
    Gs = zeros(S, S);
    
    for k = 1:sampleCount
        p = sp(k, :);
        n = sn(k, :);
        pc = floor(p([2 1]) * (S-1)) + 1;
        nkx = neighKernel + pc(1);
        nky = neighKernel + pc(2);
        for i = nkx
            for j = nky
                pn = [i j];
                if any(pn < 1 | pn > S), continue; end
                cidx = sub2ind([S, S], pn(1), pn(2));
                pg = [X(cidx) Y(cidx)];
                diff = pg - p;
                dist = norm(diff);
                
                if mask(cidx) == false || G(cidx) > dist
                    G(cidx) = dist;
                    mask(cidx) = true;
                    Gs(cidx) = sign(dot(n, diff));
                    %if k == sampleCount && Gs(cidx) == -1,  Gs(cidx) = sign(dot([1 1] / sqrt(2), diff)); end
                    if Gs(cidx) == 0, Gs(cidx) = 1; end
                end
            end
        end
    end
end

function G = fillOnes(G, mask, S, Sz)
    for k = 1:Sz
        for i = 1:S
            for j = 1:S
                jr = (S-j+1);
                if ~mask(i, jr, k)
                    G(i, jr, k) = 1;
                else
                    break;
                end
            end
        end
        for i = 1:S
            for j = 1:S
                jr = (S-j+1);
                if ~mask(jr, i, k)
                    G(jr, i, k) = 1;
                else
                    break;
                end
            end
        end
    end
end
