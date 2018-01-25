function samples = Demo_Synthesis(C, G, gG)
    colors = [hex2rgb('D8B7E8'); hex2rgb('FDCA8B')];
    ResultColor = hex2rgb('59c487');
    VolumeColor = hex2rgb('aaf7cc');
    
    if ~exist('C', 'var'), C = []; end
    set(0,'defaultfigurecolor',[1 1 1])
    figure('Name', 'Synthesis', 'Position', [1 1 1000 1000]); pause(0.1);
    axis off;
    daspect([1 1 1]);
    hold all;
    S = 200;
    lineW = 6;
    samplesW = 6;
    Min = [-1 -1];
    Max = [1 1];
    x = linspace(Min(1), Max(1), S);
    y = linspace(Min(2), Max(2), S);
    [X,Y] = meshgrid(x,y);
    scene = @ExampleBalls;
    
    % Evaluate the distance fields
    [df, gdf, r1, r2] = scene(X, Y);
    
    % Distance field to implicit surfaces
    [f, gf] = distToField(df, gdf, r1, r2);
    
    % Evaluate the operator & plot
    if nargin >= 2
        [F, ~] = blendingAll(f, gf, G, gG);
        contourf(X, Y, F, [0.5 0.5], 'LineWidth', lineW, 'LineColor', colors(1, :), 'LineStyle', 'none');
        colormap(VolumeColor);
        contour2(X, Y, F, 0.5, 'LineWidth', lineW, 'Color', ResultColor);
    else
        for i = 1:numel(f)
            cidx = i;
            contour2(X, Y, f{i}, 0.5, 'LineWidth', lineW, 'Color', colors(cidx, :));
        end        
        if nargin == 1
            if isempty(C)
                samples = [];
            else
                if iscell(C)
                    Cp = cat(1, C{:});
                else
                    Cp = C;
                end
                [df, gdf, r1, r2] = scene(Cp(:,1), Cp(:,2));
                [f, gf] = distToField(df, gdf, r1, r2);

                if numel(df) > 2
                    fc = cat(3, f{:});
                    [fcs, idx] = sort(fc, 3);
                    sf1 = fcs(:,:,end);
                    sf2 = fcs(:,:,end-1);
                    idx = reshape(idx(:, :, end-1:end), size(idx,1), []);
                    gfc = reshape(cat(4, gf{:}), [], 2, numel(df));
                    n = size(gfc, 1);
                    I = repmat((1:n)', 2, 1);
                    J = [ones(n,1); ones(n,1)*2];
                    gf1 = permute(reshape(gfc(sub2ind(size(gfc), I, J, repmat(idx(:,2), 2, 1))), [], 2), [1 3 2]);
                    gf2 = permute(reshape(gfc(sub2ind(size(gfc), I, J, repmat(idx(:,1), 2, 1))), [], 2), [1 3 2]);
                    sAlpha = gradAngle(gf1, gf2);
                    samples = [sf1 sf2 sAlpha];
                    %samples = [samples; sf2 sf1 sAlpha];
                elseif numel(df) > 1
                    sAlpha = gradAngle(gf{1}, gf{2});
                    samples = [f{1} f{2} sAlpha];
                end
            end
        end
    end
    
    if ~isempty(C)
        
        if iscell(C)
            for i = 1:length(C)
                plot(C{i}(:,1), C{i}(:,2), '.', 'MarkerEdgeColor', [0 0 0], 'MarkerSize', samplesW);
            end
        else
            plot(C(:,1), C(:,2), 'Color', [0 0 0], 'LineWidth', lineW);
        end
    end
    
    axis off;
    axis([Min(1) Max(1) Min(2) Max(2)]);
    daspect([1 1 1]);
    axis equal;
    set(gcf, 'Units', 'Inches', 'Position', [0, 0, 10, 10], 'PaperUnits', 'Inches', 'PaperSize', [10, 10])
    drawnow;
end

function contour2(X, Y, F, iso, varargin)
    cpts = contour(X, Y, F, [iso iso]);
    P = cmatToLines(cpts);
    for i = 1:length(P)
        plot(P{i}(:,1), P{i}(:,2), varargin{:});
    end
end

function [lines] = cmatToLines(P)
    P = P';
    k = 1;
    lines = {};
    while true
        if k > size(P, 1), break; end
        n = P(k, 2);
        line = P(k+1:k+n, :);
        lines{end+1} = [line; flipud(line); line];
        k = k + n + 1;
    end
end

function [f, gf] = distToField(df, gdf, r1, r2)
    n = numel(df);
    f = cell(n,1);
    for i = 1:n
        if iscell(r1)
            f{i} = c2(df{i} - r1{i}, r2{i});
        else
            f{i} = c2(df{i} - r1, r2);
        end
        gf{i} = -gdf{i};
    end
end

function alpha = gradAngle(gf1, gf2)
    gf1n = gf1 ./ sqrt(sum(gf1.^2, 3));
    gf2n = gf2 ./ sqrt(sum(gf2.^2, 3));
    dotg = max(-1, min(1, dot(gf1n, gf2n,3)));
    alpha = acos(dotg) / pi;
end

function [F, gF] = blendingAll(f, gf, G, GG)
    n = size(f, 1);
    F = f{1};
    gF = gf{1};
    for i = 2:n
        [F, gF] = blending(F, f{i}, gF, gf{i}, G, GG);
    end
end

function [F, gF] = blending(f1, f2, gf1, gf2, G, gG)
    r = linspace(0, 1, size(G,1));
    rz = linspace(0, 1, size(G,3));
    [xx, yy, zz] = meshgrid(r, r, rz);
    alpha = gradAngle(gf1, gf2);
    F = interp3(xx, yy, zz, G, f1, f2, alpha);
    gGfx = interp3(xx, yy, zz, gG(:,:,:,1), f1, f2, alpha);
    gGfy = interp3(xx, yy, zz, gG(:,:,:,2), f1, f2, alpha);
    gF = gGfx .* gf1 + gGfy .* gf2;
end

function c = c2(x, r)
    c = min(1, max(0, 0.5 - x ./ (r*2)));
end

function [D, G] = distSegment(a, b, X, Y)
    ab = b - a;
    apx = X - a(1);
    apy = Y - a(2);
    alpha = min(max((ab(1) * apx + ab(2) * apy) ./ norm(ab)^2, 0), 1);
    projx = (1 - alpha) * a(1) + alpha * b(1);
    projy = (1 - alpha) * a(2) + alpha * b(2);
    D = sqrt((X - projx).^2 + (Y - projy).^2);
    G = cat(3, X - projx, Y - projy) ./ D;
end

function [df, gf, r1, r2] = ExampleBalls(X, Y)
    r1{1} = 0.25;
    r1{2} = 0.25;
    r2{1} = 0.6;
    r2{2} = 0.6;
    p1 = [0 -0.35];
    p2 = [0 0.35];
    [df{1}, gf{1}] = distSegment(p1, p1, X, Y);
    [df{2}, gf{2}] = distSegment(p2, p2, X, Y);
end
