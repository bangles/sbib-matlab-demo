% AFFINE_TRANSFORM_P3
% computes the affine transform of a set of 3D "points"
function P_new = affine_transform_p3(P, T)

% allocate
P_new = zeros( size(P) );

%--- Homogeneous transform
% add a ros of ones 
%
% [  |    |    |  ]   [        ]   [  |    |    |  ]
% [ p1n  ...  pNn ] = [   T    ] * [ p1   ...  pn  ]
% [  |    |    |  ]   [        ]   [  |    |    |  ]
% [  1    1    1  ] = [        ]   [  1    1    1  ]
homogeneous_in = [ P, ones(length(P),1) ]';
homogeneous_out = (T*homogeneous_in)';

%--- Homogeneous -> cartesian
P_new(:,1) = homogeneous_out(:,1) ./ homogeneous_out(:,4);
P_new(:,2) = homogeneous_out(:,2) ./ homogeneous_out(:,4);
P_new(:,3) = homogeneous_out(:,3) ./ homogeneous_out(:,4);

