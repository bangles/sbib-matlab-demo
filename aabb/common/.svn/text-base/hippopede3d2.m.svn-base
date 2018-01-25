% Create a 3D Hippopede to be plotted with the mesh function
% a, b, c = Hippopede parameters
% t1, t2 = number of parameters to use along theta and phi axes
function [x, y, z] = hippopede3d2(t1, t2, a, b, c)
    % References for 2D Hippopede
    % http://mathworld.wolfram.com/Hippopede.html
    % http://en.wikipedia.org/wiki/Hippopede
    % http://en.wikipedia.org/wiki/Lemniscate_of_Booth
    % http://curvebank.calstatela.edu/hippopede/hippopede.htm
    % http://en.wikipedia.org/wiki/Polar_coordinate

    % Get parameters
    theta = linspace(0, pi, t1);
    phi = linspace(0, 2*pi, t2);

    % Create grid
    [theta, phi] = meshgrid(theta, phi);

    % Use polar equation
    u = (cos(theta).^2).*(sin(phi).^2);
    v = (sin(theta).^2).*(sin(phi).^2);
    w = (cos(phi).^2);
    rs = (a*u + b*v + c*w)./...
         (u.*u + v.*v + w.*w + 2*u.*v + 2*u.*w + 2*v.*w);
    r = sqrt(rs);
    % Transform back
    x = r.*sin(phi).*cos(theta);
    y = r.*sin(phi).*sin(theta);
    z = r.*cos(phi);
end
