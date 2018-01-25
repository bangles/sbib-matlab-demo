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
function V = hippopede_to_volume2(a, b, c, pmin, delta, sz)

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
            % Test for in/out
            if (x^2 + y^2 + z^2)^2 <= a*x^2 + b*y^2 + c*z^2
                V(i, j, k) = 1;
            end
        end
    end
end
