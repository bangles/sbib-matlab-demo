%
% Create a volume that contains a Hippopede shape
% To understand what shape will come out, plot the 3D surface with
% the script test_Hippopede3d.m
%
% a, b = Hippopede parameters
% pmin, delta = used to convert between cartesian coordinates and volume
% indices
% pmin = position of the corner of the volume
% delta = position increment for each voxel
% sz = size of volume to create
% V = output volume, voxels = 1 are inside the function
%
% Example:
% V = hippopede_to_volume(1, 0.95, [-2 -2 -2], 0.2, [20 20 20]);
% imagesc(V(:,:,11))
%
function V = hippopede_to_volume(a, b, pmin, delta, sz)

% Init volume
V = zeros(sz(1), sz(2), sz(3));

% Test each voxel
for i = 1:size(V, 1)
    for j = 1:size(V, 2)
        for k = 1:size(V, 3)
            % Get cartesian coordinates for voxel
            x = (j-1)*delta + pmin(2);
            y = (i-1)*delta + pmin(1);
            z = (k-1)*delta + pmin(3);
            % Convert to spherical coordinates
            % Point (0, 0, 0) is inside the function, so we can safely
            % add it to the volume and avoid division by zero when
            % converting to spherical coordinates
            if (abs(x) < eps) && (abs(y) < eps) && (abs(z) < eps)
                V(i, j, k) = 1;
            else
                % Spherical coordinates
                r = sqrt(x^2 + y^2 + z^2);
                theta = acos(z/r);
                % This if statement does not make much sense at first,
                % but it's here to avoid NaN and get a better function
                % approximation (if it's not added, the point in the
                % center of the example is empty and creates a hole)
                if (abs(x) < eps) % atan(inf) = pi/2
                    phi = pi/2;
                else
                    phi = atan(y/x);
                end
                % Compute radius of function
                rf = sqrt(4*b*(a - b*(sin(phi).^2)));
                % Check radius of coordinate against radius of function
                if rf > r
                    % It's in
                    V(i, j, k) = 1;
                end
            end
        end
    end
end
