% AFFINE_TRANSFORM_P3
% computes the affine transform of a set of 3D "normals"
function N_new = affine_transform_n3(N, T)

% allocate
N_new = zeros( size(N) );

%--- Homogeneous transform
% Simply kill the 4th row and column from T
% [  |    |    |  ]   [        ]   [  |    |    |  ]
% [ N1n  ...  Nmn ] = [   T    ] * [ N1   ...  Nm  ]
% [  |    |    |  ]   [        ]   [  |    |    |  ]
T = T(1:3,1:3);
homogeneous_in = N';
homogeneous_out = (T*homogeneous_in)';

%--- Homogeneous -> cartesian
N_new(:,1) = homogeneous_out(:,1);
N_new(:,2) = homogeneous_out(:,2);
N_new(:,3) = homogeneous_out(:,3);

