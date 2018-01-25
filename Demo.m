 function Demo()
    % Simulate a user sketch and discretize it into sample points (in Euclidean space)
    r1 = 0.25;
    d1 = 0.15;
    d2 = 0.15;
    d3 = 0.15;
    p1 = [0 -0.35];
    p3 = p1 + [-r1 0];
    p4 = p1 + [-r1 d1];
    p5 = [-d2 -d3];
    p6 = [-d2 0];
    C = interpCubicBezier(p3, p4, p5, p6, 300);
    
    % Get samples from the Euclidean space to the Operator space
    Y = Demo_Synthesis(C);

    % Fit our template to the samples
    [~, ~, ~, Patches] = Demo_Fitting(Y);
    
    % Compute the operator in a 3D grid
    % G: the 3D grid of the operator values
    % gG: the 2D gradients of the operator (4D grid)
    [G, gG] = generateOperator_fast2(Patches, 100, true);
    
    % Test the operator
    Demo_Synthesis([], G, gG);
end

function C = interpCubicBezier(a,b,c,d,n)
    t = linspace(0, 1, n)';
    C = (1-t).^3 * a + 3 * (1-t).^2 .* t * b + 3 * (1-t) .* t.^2 * c + t.^3 * d;
end
