classdef BSplineSurface<handle
    properties
        U
        V
        ku
        kv
        grid
        points
        resU
        resV
    end
    methods
        function obj = BSplineSurface(a, b, N, M, ku, kv)
            obj.ku = ku;
            obj.kv = kv;
            obj.U = [zeros(1,ku-1) linspace(0,1,N-ku+2) ones(1,ku-1)];
            obj.V = [zeros(1,kv-1) linspace(0,1,M-kv+2) ones(1,kv-1)];
            
            n = 1 / (N-1);
            m = 1 / (M-1);
            obj.points = zeros(N * M, 3);
            for i = 1:N
                for j = 1:M
                    obj.points((j-1)*N + i, :) = a + [(i-1)*n, (i-1)*n, (j-1)*m] .* (b - a);
                end
            end
            obj.grid = reshape(1:M*N, N, M);
            obj.resU = 50;
            obj.resV = 50;
        end
        
        function [V, T, W] = polygonize(obj)
            N = obj.resU;
            M = obj.resV;
            V = zeros(N * M, 3);
            W = zeros(N * M, numel(obj.grid));
            
            
            cV = findVs(obj, M);
            
            for j = 1:M
                v = cV(j);
                cU = findUs(obj, N, v);
                for i = 1:N
                    u = cU(i);
                    [p, w] = obj.eval(u, v);
                    k = i + (j-1) * N;
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
        
        function U = findUs(Patch, S, v)
            s = 10;
            t = linspace(0, 1, S)';
            ts = linspace(0, 1, s)';
            sp = zeros(s, 3);
            for i = 1:s
                sp(i, :) = Patch.eval(ts(i), v);
            end
            %sp = sp(:,3);
            d = [0; cumsum(sqrt(sum((sp(2:end,:) - sp(1:end-1,:)).^2, 2)))];
            d = d ./ d(end);

            U = zeros(S, 1);
            U(1) = 0.0;
            U(S) = 1.0;            
            i = 1;
            k = 2;
            while k < S
                a = d(i);
                b = d(i+1);
                c = t(k);
                if c >= a && c <= b
                    alpha = (c - a) / (b - a);
                    U(k) = (1 - alpha) * ts(i) + alpha * ts(i+1);
                    k = k + 1;
                elseif c > b
                    i = i + 1;
                end
            end
        end

        function [p, w] = eval(obj, u, v) % TODO: Vectorize
            p = zeros(1, 3);
            N = size(obj.grid, 1) - 1;
            M = size(obj.grid, 2) - 1;
            w = zeros(1, (N+1) * (M+1));   

            for i = 0:N
                for j = 0:M
                    vidx = obj.grid(i+1, j+1);
                    vidx2 = j * (N+1) + i + 1;
                    w(vidx2) = deboorcox(i, obj.ku, u, obj.U) * deboorcox(j, obj.kv, v, obj.V);
                    p = p + w(vidx2) * obj.points(vidx, :);
                end
            end
        end
        
        function p = get(obj, i, j)
            p = obj.points(obj.grid(i,j), :);
        end
        
        function obj = updatePts(obj, grid, pts)
            idx = reshape(grid, [], 1);
            obj.points = pts(idx, :);
        end
    end
    
    methods(Static)
        function [V, T, W] = polygonizePatches(Patches)
            V = [];
            T = [];
            for i = 1:length(Patches)
                if Patches{i}.resU == [], Patches{i}.resU = 40; end
                if Patches{i}.resV == [], Patches{i}.resV = 40; end
                
                [v, t] = Patches{i}.polygonize();
                T = [T; t + size(V, 1)];
                V = [V; v];
            end
        end
    end
end