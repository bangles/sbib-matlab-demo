% Create a 3D Hippopede to be plotted with the mesh function
% a, b = Hippopede parameters
% t1, t2 = number of parameters to use along theta and phi axes
function [x, y, z] = hippopede3d(t1, t2, a, b)
    % References for 2D Hippopede
    % http://mathworld.wolfram.com/Hippopede.html
    % http://en.wikipedia.org/wiki/Hippopede
    % http://en.wikipedia.org/wiki/Lemniscate_of_Booth
    % http://curvebank.calstatela.edu/hippopede/hippopede.htm
    % http://en.wikipedia.org/wiki/Polar_coordinate

    % Get parameters
    phi = linspace(0, pi, t1);
    theta = linspace(0, 2*pi, t2);

    % Create grid
    [phi, theta] = meshgrid(phi, theta);

    % Use polar equation
    r = sqrt(4*b*(a - b*(sin(theta).^2)));
    x = r.*sin(phi).*cos(theta);
    y = r.*sin(phi).*sin(theta);
    z = r.*cos(phi)*0.2;
end
