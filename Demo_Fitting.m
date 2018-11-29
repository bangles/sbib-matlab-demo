function [V, T, vi, Pch] = Demo_Fitting(samples)
    global X Y Yr Y1 Y2 Yr1 Yr2 Yf Patches Z P FC MC R mi res iter fullcontact regIter finIter symmetry;
    addpath('aabb');
    res = 40;
    iter = 0;
    regIter = 20;
    finIter = 0;
    symmetry = true;
    fullcontact = false;
    
    [X, Patches] = createTemplate();
    Z = X;
    
	% Load the samples
    Yr = samples;
    Yr1 = [];
    Yr2 = [];
    Yf = [];
    [~, Yr] = samplesPreprocessing(Yr);
    [~, Yr1] = samplesPreprocessing(Yr1);
    [~, Yr2] = samplesPreprocessing(Yr2);
    Y = Yr;
    Y1 = Yr1;
    Y2 = Yr2;
    
    % Find the vertices of interest
    mi = findVertices(X, Patches);
    MC = mergedDOFs(Z, Patches, mi, symmetry);
    
	[FC, P] = getFixedVertices(MC);
    
    P = full(P);
    S = size(Z, 1);
    R = eye(S * 3);
    
    
    if ~isempty(MC)        
        for i = 1:size(MC,1)
            R(MC(i,2), MC(i,1)) = 1;
        end
        R(:, MC(:,2)) = [];
    end
    
    initGUI(true);
    doRun();
    
    [V, T, vi] = polygonizeFinal(Z, Patches, res);
    
    % Update patches
    for i = 1:length(Patches)
        N = size(Patches{i}.grid, 1);
        M = size(Patches{i}.grid, 2);
        ku = Patches{i}.k1;
        kv = Patches{i}.k2;
        
        Pch{i} = BSplineSurface([0 0 0], [0 0 0], N, M, ku, kv);
        Pch{i}.updatePts(Patches{i}.grid, Z);
    end
end

function savePatches(P, Z, iter)
    for i = 1:length(P)
        N = size(P{i}.grid, 1);
        M = size(P{i}.grid, 2);
        ku = P{i}.k1;
        kv = P{i}.k2;
        
        Patches{i} = BSplineSurface([0 0 0], [0 0 0], N, M, ku, kv);
        Patches{i}.updatePts(P{i}.grid, Z);
    end
end

function run()
    global Y Y1 Y2 Yf Z Patches FC R P res mi iter symmetry fullcontact;
    
    % Build the linear system
    [A1, b1] = pointToPlaneEnergy2(Y, Y1, Y2, Yf, Z, Patches, res);
    [A2, b2] = laplacianSliceEnergy(Z, Patches, mi, false);
    [A3, b3] = laplacianLineEnergy(Z, Patches, mi);
    [A4, b4] = TikhonovEnergy(Z);
    [A5, b5] = correctionEnergy(Z, mi, Patches, symmetry, fullcontact, res);
    [A7, b7] = spineSmoothEnergy(Z, mi);
    
    n = length(Y) + length(Y1) + length(Y2) + length(Yf);
    
    % Weights
    w(1) = 1 / n; % Matching
    w(2) = max(1000 * 0.05^(iter), 10^-3); % Slice smoothness
    w(3) = max(1000 * 0.05^(iter), 10^-3); % Line smoothness
    w(4) = 10^-3; % Tikhonov
    w(5) = 10^3; % Correction
    w(7) = 10^-1; % Spine smoothness
    w = sqrt(w);
    
    A = [
        A1 * w(1); 
        A2 * w(2); 
        A3 * w(3);
        A4 * w(4);
        A5 * w(5);
        A7 * w(7);
        ];
    b = [
        b1 * w(1); 
        b2 * w(2); 
        b3 * w(3);
        b4 * w(4);
        b5 * w(5);
        b7 * w(7);
        ];
    
    % Adjust A with the merged DOFs
    A = A * R;
    
    fixedN = size(FC, 1);
	Af = P * (A' * A) * P';
	bf = P * A' * b;
	Af1 = Af(1:(end - fixedN), 1:(end - fixedN));
	Af2 = Af(1:(end - fixedN), (end - fixedN + 1):end);
	bf1 = bf(1:(end - fixedN));
	x2 = FC(:, 2);
	bf2 = bf1 - Af2 * x2;
	
	x1 = Af1 \ bf2;
	x = P' * vertcat(x1, x2);
    
    % Unmerge the DOFs
    x = R * x;
    
    % Extract the solution
    Z = reshape(x, [], 3);
    
    iter = iter + 1; pause(1);
    savePatches(Patches, Z, iter);
end

function [A, b] = pointToPlaneEnergy(Y, X, Patches, res)
    if isempty(Y), A = []; b = []; return; end

    [V, T, Wb] = polygonizePatches(X, Patches, res, res);
    
    K = closestTriangles(V, T, Y);
    M = size(Y, 1);
    S = size(X, 1);
    
    A = zeros(M, S * 3);
    for i = 1:M
        vIdx = K(i, 7:9);
        n = K(i, 4:6);
        w = K(i, 1:3); % Triangle weights
        Wbi = Wb(vIdx, :); % Vertex patch weights 
        Wbw = w * Wbi;
        A(i, :) = [Wbw * n(1), Wbw * n(2), Wbw * n(3)];
    end
    
    b = dot(Y,K(:,4:6),2);
end

function [A, b] = pointToPlaneEnergy2(Y, Y1, Y2, Yf, X, Patches, res)
    [A1, b1] = pointToPlaneEnergy([Y1; Yf], X, Patches(1), res);
    [A2, b2] = pointToPlaneEnergy([Y2; Yf], X, Patches(2), res);
    [A3, b3] = pointToPlaneEnergy(Y, X, Patches(1:2), res);
    
    A = vertcat(A1, A2, A3);
    b = vertcat(b1, b2, b3);
end

function [A, b] = correctionEnergy(Z, mi, Patches, symmetry, fullcontact, res)
    S = length(Z);
    M = length(mi.slice);
    A = zeros(0, 3*S);
    b = zeros(0, 1);
    
    % Keep control points inside the [0 1]^3 space
    if 0
    for i = 1:S
        if any(Z(i,:) > 1 | Z(i,:) < 0)
            A(end+1:end+3,:) = zeros(3,S*3);
            A(end-2,i) = 1;
            A(end-1,i+S) = 1;
            A(end,i+2*S) = 1;
            p = min(max(Z(i,:), 0), 1);
            b(end+1:end+3,1) = p';
        end
    end
    end
    
    minDist = 0.01;
    % Maintain the slice order
    if false
    for i = 1:M-1
        a1 = Z(mi.slice{i}(1), 3);
        a2 = Z(mi.slice{i+1}(1), 3);
        if a1 >= a2 - minDist
            A(end+1, mi.slice{i}(1)+2*S) = 1;
            A(end+1, mi.slice{i+1}(1)+2*S) = 1;
            b(end+1, 1) = min(max(a2 - minDist, 0), 1);
            b(end+1, 1) = min(max(a1 + minDist, 0), 1);
            %[a2 - eps, a1 + eps]
        end
    end
    end
    
    % Keep the control points separate
    if false
    for i = 1:S
        for j = i+1:S
            if find(mi.spine1 == i | mi.spine1 == i) == find(mi.spine2 == j | mi.spine2 == j)
                continue;
            end
            
            p1 = Z(i,:);
            p2 = Z(j,:);
            dir = p1 - p2;
            n = norm(p1 - p2);
            if n < minDist
                if n < 0.00001
                    dir = randn(1,3);
                    n = norm(dir);
                end
                v = minDist * dir / n;
                for k = 0:2
                    A(end+1, [i j] + k*S) = [1 -1];
                    b(end+1, 1) = v(k+1);
                end
            end
        end
    end
    end
    
    % Keep points in their half space
    if symmetry
    for i = Patches{1}.grid(:)'
        if Z(i, 1) < Z(i, 2)
            n = [-1 1 0] / sqrt(2);
            p = Z(i,:) - n * dot(n, Z(i,:));
            %for k = 0:2
            %    A(end+1, i + k*S) = 1;
            %    b(end+1, 1) = p(k+1);
            %end
            A(end+1, i + [0 S S*2]) = n;
            b(end+1, 1) = dot(n, p);
        end
    end
    end
    
    if false
    for i = 1:length(mi.slice{1})
        for k = 0:2
            A(end+1, mi.slice{1}(i)+k*S) = 1;
            b(end+1, 1) = Z(mi.slice{1}(i), k+1);
            A(end+1, mi.slice{end}(i)+k*S) = 1;
            b(end+1, 1) = Z(mi.slice{end}(i), k+1);
        end
    end
    end
    
    
    % Project control points on the top or left side
    if fullcontact
    for i = 1:M
        idx = mi.spine1(i);
        p = Z(idx, 1:2);
        n = [1 0];
        if p(1) < p(2), n = [0 1]; end
        
        A(end+1, idx) = n(1);
        A(end+1, idx+S) = n(2);
        b(end+1, 1) = 1;
        b(end+1, 1) = 1;
    end
    
    for i = 1:M
        idx = mi.spine1(i);
        p = Z(idx, 1:2);
        if p(1) < 0.5
            A(end+1, idx) = 1;
            b(end+1, 1) = 0.5;
        end
        if p(2) < 0.5
            A(end+1, idx+S) = 1;
            b(end+1, 1) = 0.5;
        end
    end
    end
end

function [A, b] = TikhonovEnergy(Z)
    b = reshape(Z, [], 1);
    A = speye(length(b));
end

function [A, b] = laplacianSliceEnergy(X, Patches, mi, fullcontact)
    [N, M] = size(Patches{1}.grid);
    if fullcontact, N = N - 1; end
    
    S = size(X, 1);
    A = zeros(0, 3*S);
    for i = 1:M
        for j = 2:N-1
            for k = 0:2
                A(end+1, mi.slice{i}([j-1 j j+1])+k*S) = [-1 2 -1];
                A(end+1, mi.slice{i}([end-j end-j+1 end-j+2])+k*S) = [-1 2 -1];
                if i == M, A(end+1, mi.slice{i}([j-1 j j+1])+k*S) = [-1 2 -1]; end
            end
        end
    end
    b = zeros(size(A,1), 1);
end

function [A, b] = laplacianLineEnergy(X, Patches, mi)
    [N, M] = size(Patches{1}.grid);
    S = size(X, 1);
    A = zeros(0, 3*S);
    for i = 2:M-1
        for j = 1:2*N
            for k = 0:2
                a = mi.slice{i-1}(j);
                b = mi.slice{i}(j);
                c = mi.slice{i+1}(j);
                A(end+1, [a b c] + k*S) = [1 -2 1];
            end
        end
    end
    b = zeros(size(A,1), 1);
end

function [A, b] = spineSmoothEnergy(Z, mi)
    M = length(mi.slice);
    N = length(mi.slice{1});
    S = size(Z, 1);
    
    v = [N/2 - 1, N/2, N/2 + 2];
    A = zeros(3 * M, 3 * S);
    b = zeros(3 * M, 1);
    for i = 1:M
        if false
        i1 = mi.slice{i}(v(1));
        i2 = mi.slice{i}(v(2));
        i3 = mi.slice{i}(v(3));
        v1 = Z(i1, :) - Z(i2, :);
        v2 = Z(i3, :) - Z(i2, :);
        v1 = v1 / norm(v1);
        v2 = v2 / norm(v2);
        x = acos(dot(v1, v2, 2));
        c1 = 10^4;
        c2 = pi/2 + pi/8;
        c3 = pi;
        if x < c2
            w1 = 0;
        elseif x > c3
            w1 = 1;
        else
            w1 = 1 - (1 - ((x - c2) / (c3 - c2))^2)^2;
        end
        w = (c1^w1 - 1) / c1;
        [x w]
        w = sqrt(w);
        end
        
        for k = 0:2
            A(i + M*k, mi.slice{i}(v) + k*S) = [1 -2 1] ;
        end
    end
end

function MC = mergedDOFs(X, Patches, mi, symmetry)
    G1 = Patches{1}.grid;
    M = size(G1, 2);
    N = size(G1, 1);
    S = size(X, 1);    
    
    % Patches attachment
    MC = [];
    MC = [MC; mi.spine1 mi.spine2; mi.spine1+S mi.spine2+S; mi.spine1+2*S mi.spine2+2*S];
    MC = [MC; mi.line0 mi.line0o; mi.line0+2*S mi.line0o+2*S];
    MC = [MC; mi.line1+S mi.line1o+S; mi.line1+2*S mi.line1o+2*S];
    MC = [MC; mi.slice{1} mi.slice{2}; mi.slice{1}+S mi.slice{2}+S];
    MC = [MC; mi.slice{end} mi.slice{end-1}; mi.slice{end}+S mi.slice{end-1}+S];
    
    for i = 1:M
        n = length(mi.slice{i});
        for j = 2:n
            MC = [MC; mi.slice{i}(1)+2*S mi.slice{i}(j)+2*S];
        end
        if symmetry
            for j = 1:n
                MC = [MC; mi.slice{i}(j), mi.slice{i}(n-j+1)+S];
            end
        end
    end
    
    [~,I]=sort(MC(:,2));
    MC=MC(I,:);
    
    a = num2cell(MC,2);
    i = 1;
    while i <= size(a,1)
        lg = [];
        for j = 1:size(a,1)
            if j == i, continue; end
            if any(ismember(a{i}, a{j}))
                lg = [lg; j];
                a{i} = [a{i} a{j}];
            end
        end
        a(lg) = []; % Remove the duplicate lines
        i = i + 1;
    end
    MC = [];
    for i = 1:size(a,1)
        a{i} = unique(a{i});
        for j = 2:length(a{i})
            MC(end+1, :) = [a{i}(1) a{i}(j)];
        end
    end
end

function meshInfo = findVertices(v, Patches)
    % . Find the vertices of interest
    meshInfo = struct();
    meshInfo.line0 = find(all(v(:, 1:2) == [0.5 0.0], 2));
    meshInfo.line1 = find(all(v(:, 1:2) == [0.0 0.5], 2));
    meshInfo.spine1 = find(all(v(:, 1:2) == [0.5 0.5], 2) & ismember(1:size(v, 1), Patches{1}.grid)');
    meshInfo.spine2 = find(all(v(:, 1:2) == [0.5 0.5], 2) & ismember(1:size(v, 1), Patches{2}.grid)');
    meshInfo.line0o = Patches{1}.grid(2,:)';
    meshInfo.line1o = Patches{2}.grid(2,:)';
    n = size(Patches{1}.grid,2);
    for i = 1:n
        meshInfo.slice{i} = [Patches{1}.grid(:,i); Patches{2}.grid(:,i)];
    end
    
    % Sorting
    [~, idx] = sort(v(meshInfo.line0, 3));
    meshInfo.line0 = meshInfo.line0(idx);
    [~, idx] = sort(v(meshInfo.line1, 3));
    meshInfo.line1 = meshInfo.line1(idx);
    [~, idx] = sort(v(meshInfo.spine1, 3));
    meshInfo.spine1 = meshInfo.spine1(idx);
    [~, idx] = sort(v(meshInfo.spine2, 3));
    meshInfo.spine2 = meshInfo.spine2(idx);
    [~, idx] = sort(v(meshInfo.line0o, 3));
    meshInfo.line0o = meshInfo.line0o(idx);
    [~, idx] = sort(v(meshInfo.line1o, 3));
    meshInfo.line1o = meshInfo.line1o(idx);
    for i = 1:n
        [~, idx] = sortrows(v(meshInfo.slice{i}, 1:2), [1 -2]);
        meshInfo.slice{i} = meshInfo.slice{i}(idx);
    end
end

function [FC, P] = getFixedVertices(MC)
	global X mi;
    
    fp = [
        mi.line0(1), 0.5, 0, 0;
        mi.line0(end), 0.5, 0, 1;
        mi.line1(1), 0, 0.5, 0;
        mi.line1(end), 0, 0.5, 1];
    
	fpp = zeros(0, 3);
    for i = 1:size(mi.slice{1}, 1)
		fpp(end+1, :) = [mi.slice{1}(i), 3, 0];
        fpp(end+1, :) = [mi.slice{end}(i), 3, 1];
        %fpp(end+1, :) = [mi.slice{1}(i), 1, X(mi.slice{1}(i), 1)];
        %fpp(end+1, :) = [mi.slice{1}(i), 2, X(mi.slice{1}(i), 2)];
    end
    
    for i = 1:size(mi.line0,1)
        fpp(end+1, :) = [mi.line0(i), 1, 0.5];
        fpp(end+1, :) = [mi.line0(i), 2, 0];
        fpp(end+1, :) = [mi.line1(i), 1, 0];
        fpp(end+1, :) = [mi.line1(i), 2, 0.5];
        fpp(end+1, :) = [mi.line1(i), 3, X(mi.line1(i), 3)];
    end
    
    S = size(X, 1);
	N = size(fp, 1);
	M = size(fpp, 1);
	FC = zeros(N * 3 + M, 2);
    for i = 1:N
		for j = 0:2
			FC(i + j * N, :) = [fp(i, 1) + j * S, fp(i, 2 + j)];
		end
    end
    for i = 1:M
		FC(3 * N + i, :) = [fpp(i, 1) + (fpp(i, 2) - 1) * S, fpp(i, 3)];
    end
    
    FC = unique(FC, 'rows');
    [~,smc] = sort(MC(:,2));
    MC = MC(smc, :);
    tr1 = ismember(FC(:,1), MC(:,2));
    tr2 = ismember(MC(:,2), FC(:,1));
    FC(tr1, 1) = MC(tr2, 1);
        
    FC = unique(FC, 'rows');
    
	P = speye(S * 3, S * 3);
	fixedIdx = FC(:, 1);
	otherIdx = setdiff(1:(S * 3), fixedIdx);
	P = [P(otherIdx, :); P(fixedIdx, :)];
    
    [r, ~] = find(P(:, MC(:,2)));
    P(:,  MC(:,2)) = [];
    P(r, :) = [];
end

function [X, Patch] = createTemplate()
    N = 5;
    M = 5;
    
    [X1, G1] = createPatch([0.5 0 0], [0.5 0.5 1], N, M);
    [X2, G2] = createPatch([0 0.5 0], [0.5 0.5 1], N, M);
    
    k = 3; % Order
    U = [zeros(1,k-1) linspace(0,1,N-k+2) ones(1,k-1)];
    V = [zeros(1,k-1) linspace(0,1,M-k+2) ones(1,k-1)];    
    
    n = size(X1, 1);
    X = [X1; X2];
    Patch = cell(1,2);
    for i = 1:2
        Patch{i}.k1 = k;
        Patch{i}.k2 = k;
        Patch{i}.U = U;
        Patch{i}.V = V;
    end
    Patch{1}.grid = G1;
    Patch{2}.grid = G2 + n;
end

function [P, G] = createPatch(a, b, N, M)
    n = 1 / (N-1);
    m = 1 / (M-1);
    P = zeros(N * M, 3);
    for i = 1:N
        for j = 1:M
            P((j-1)*N + i, :) = a + [(i-1)*n, (i-1)*n, (j-1)*m] .* (b - a);
        end
    end
    G = reshape(1:M*N, N, M);
end

function [V, T, vi, Pch] = polygonizeFinal(Z, Patches, res)
    [V, T] = polygonizePatches(Z, Patches(1:2), res, res);
    n = size(T, 1);
    m = size(V, 1);
    
    vi.xTris = 1:n/2;
    vi.yTris = n/2+1:n;
    
    if length(Patches) == 3
        [Vf, Tf] = polygonizePatches(Z, Patches(3), 2, res);
        tr = [];
        for i = 1:size(Tf,1)
            for j = 1:3
                idx1 = Tf(i, j);
                idx2 = Tf(i, 1+mod(j, 2));
                if mod(idx1, 2) + mod(idx2, 2) == 1 && norm(Vf(idx1, :) - Vf(idx2, :)) < 0.01
                    tr(end+1) = i;
                end
            end
        end
        Tf(tr, :) = [];
        V = [V; Vf];
        T = [T; Tf + m];
        vi.finTris = n+1:size(T,1);
    end
    
    % Patches
end

function [V, T, W] = polygonizePatches(X, Patches, N, M)
    n = length(Patches);
    nv = N * M;
    S = size(X, 1);
    V = [];
    T = [];
    W = zeros(nv * n, S);
    for i = 1:n
        [v, t, w] = polygonizePatch(X, Patches{i}, N, M);
        T = [T; t + size(V, 1)];
        V = [V; v];
        W(1+nv*(i-1):nv*i, reshape(Patches{i}.grid, [], 1)) = w;
    end
end

function [V, T, W] = polygonizePatch(P, G, N, M)
    V = zeros(N * M, 3);
    W = zeros(N * M, numel(G.grid));
    for i = 1:N
        u = (i-1) / (N-1);
        for j = 1:M
            v = (j-1) / (M-1);
            [p, w] = PatchEval(P, G, u, v);
            k = i + (j-1)*N;
            V(k, :) = p;
            W(k, :) = w;
        end
    end
    
    % Triangulation
    a = reshape((N*(0:M-2)' + (1:N-1))', [], 1);
    b = a + 1;
    c = a + N + 1;
    d = a + N;
    T = [a b c; a c d];
end

function [p, w] = PatchEval(V, Patch, u, v) % TODO: Vectorize
	p = zeros(1, 3);
	N = size(Patch.grid, 1) - 1;
	M = size(Patch.grid, 2) - 1;
    w = zeros(1, (N+1) * (M+1));   
    
	for i = 0:N
		for j = 0:M
            vidx = Patch.grid(i+1, j+1);
            vidx2 = j * (N+1) + i + 1;
            w(vidx2) = deboorcox(i,Patch.k1,u,Patch.U) * deboorcox(j,Patch.k2,v,Patch.V);
			p = p + w(vidx2) * V(vidx, :);
		end
    end
end

function [Ypp, Yr] = samplesPreprocessing(Y)    
    if isempty(Y)
        Ypp = [];
        Yr = [];
        return;
    end
    
    th = 0.05;
    Y = Y(Y(:,1) > th & Y(:,2) > th, :);

    eps = 0.05;
    step = 0.05;    
    Ys = sort(Y(:,3));
    a = Ys(1);
    b = Ys(end);
    Ra = 0:step:a-step;
    Rb = b+step:step:1;
    
    Ya = Y(Y(:,3) < a + eps, :);
    AlphaA = reshape(repmat(Ra, size(Ya,1), 1), [], 1);
    Ya = repmat(Ya, length(Ra),1);
    Ya(:,3) = AlphaA;
    
    Yb = Y(Y(:,3) > b - eps, :);
    AlphaB = reshape(repmat(Rb, size(Yb,1), 1), [], 1);
    Yb = repmat(Yb, length(Rb),1);
    Yb(:,3) = AlphaB;
    
    Ypp = [Y; Ya; Yb];
    Yr = Y;
end

function K = closestTriangles(V, Tris, Y)
    M = size(Y, 1);
    K = zeros(M, 16);
    global footpoints indices barycentric;
    mesh = struct('vertices', V, 'faces', Tris);
    search = PatchSearcher(mesh);
    [footpoints, indices, barycentric] = search.nn(Y);
    
    for i = 1:M
        T = Tris(indices(i), :);
        Tidx = indices(i);
        
        ab = V(T(2), :) - V(T(1), :);
        ac = V(T(3), :) - V(T(1), :);
        nt = cross(ab, ac);
        nt = nt / norm(nt);
        
        diff = footpoints(i, :) - Y(i, :);
        n = diff / norm(diff);
        
        if any(isnan(n)), n = nt; end    
        
        [u, v, w] = baryc(V(T(1), :), V(T(2), :), V(T(3), :), footpoints(i, :));
        K(i, :) = [u v w n T Tidx footpoints(i, :) nt];
    end
end

function [u, v, w] = baryc(a, b, c, p)
    v0 = b - a;
    v1 = c - a;
    v2 = p - a;
    d00 = dot(v0, v0);
    d01 = dot(v0, v1);
    d11 = dot(v1, v1);
    d20 = dot(v2, v0);
    d21 = dot(v2, v1);
    denom = d00 * d11 - d01 * d01;
    v = (d11 * d20 - d01 * d21) / denom;
    w = (d00 * d21 - d01 * d20) / denom;
    u = 1.0 - v - w;
end
%==========================================================================
%--------------------------------- GUI ------------------------------------
%==========================================================================

function initGUI(autorun)
	figure('Name', 'Registration', 'Position', [20 20 800 800], 'CloseRequestFcn', @doExit);
	set(gca,'Ydir','reverse');
    if ~autorun || true
        uicontrol('style', 'pushb', 'Position', [210 20 60 40], 'string', 'Step', 'callback', @doStep);
        uicontrol('style', 'pushb', 'Position', [280 20 60 40], 'string', 'Run', 'callback', @doRun);
        uicontrol('style', 'pushb', 'Position', [350 20 60 40], 'string', 'Reset', 'callback', @doReset);
        uicontrol('style', 'pushb', 'Position', [420 20 60 40], 'string', 'Stop', 'callback', @doStop);
        uicontrol('style', 'pushb', 'Position', [490 20 60 40], 'string', 'Export', 'callback', @doExport);
    end
    drawnow();
end

function showResults()
	global Y Y1 Y2 Yf Z Patches res 
	cla; hold on;
    line3 = @(A, B, varargin) plot3([A(1), B(1)], [A(3), B(3)], [A(2), B(2)], varargin{:});
    points3 = @(A, varargin) scatter3(A(:, 1), A(:, 3), A(:, 2), varargin{:});
    trisurf3 = @(T, A, varargin) trisurf(T, A(:, 1), A(:, 3), A(:, 2), varargin{:});
    
    if size(Y, 1) > 0
        points3(Y, 30, 'r', 'filled');
    end

    if size(Yf, 1) > 0
        points3(Yf, 30, 'b', 'filled');
    end
    
    if size(Y1, 1) > 0
        points3(Y1, 30, 'r', 'filled');
    end
    
    if size(Y2, 1) > 0
        points3(Y2, 30, 'g', 'filled');
    end
	
    % Display the mesh
    for i = 1:length(Patches)
        if true
            % Control mesh
            N = size(Patches{i}.grid, 1);
            M = size(Patches{i}.grid, 2);
            points3(Z(Patches{i}.grid, :), 'g', 'filled');
            for j = 1:N
                for k = 1:M
                    p = Z(Patches{i}.grid(j, k), :);
                    if j < N
                        px = Z(Patches{i}.grid(j+1, k), :);
                        line3(p, px, 'Color', [0.5 0.8 0.9], 'LineWidth', 2.0);
                    end
                    if k < M
                        py = Z(Patches{i}.grid(j, k+1), :);
                        line3(p, py, 'Color', [0.5 0.8 0.9], 'LineWidth', 2.0);
                    end
                end
            end
        end
    end
    [V, T] = polygonizePatches(Z, Patches(1:2), res, res);
    trisurf3(T, V, 'FaceColor', [0.1 0.5 1]);
    
	hold off;
	grid on;
	axis([0 1 0 1 0 1]);
	xlabel('f0');
	zlabel('f1');
	ylabel('\theta');
	axis vis3d;
	rotate3d on;
    %view([45, 20]);
    drawnow;
end

function doStep(~,~)
	global mustStop;
	mustStop = false;
    run();
    showResults();
end

function doRun(~,~)
	global mustStop fullcontact Z regIter finIter;
	mustStop = false;
	%saveas(gcf,'0.png');
    for i = 1:regIter
        Zp = reshape(Z, [], 1);
        run();
        Zc = reshape(Z, [], 1);
		
        if mustStop == true, break; end
        if i > 40 && norm(Zc-Zp) < 10^-4, disp('Convergence reached.'); break; end
		
		showResults();
        drawnow;
        
		%saveas(gcf, strcat(int2str(i), '.png'));
    end
    
    showResults();
    drawnow;
end

function doReset(~,~)
    global Z;
    global X;
    Z = X;
%    initFinRefinement();
    showResults();
end

function doStop(h,e)
    global mustStop;
    mustStop = true;
end

function doExit(h,e)
	doStop(h,e);
	delete(gcf);
end

function doExport(h, e)
    global Zf triangles;
    exportOBJ(Zf, triangles, 'export.obj');
end