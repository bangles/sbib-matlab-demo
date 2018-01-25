% PCLOUD_AFFINE_TRANSFORM
%
% applies an affine transform to a point cloud
% 
% T: a 4x4 affine transform matrix
% P: pcloud struct

% Copyright (c) 2008 Andrea Tagliasacchi
% All Rights Reserved
% email: andrea.tagliasacchi@gmail.com
% $Revision: 1.0$  02 Jul. 2008: created by Andrea Tagliasacchi
% $Revision: 2.0$  13 Dec. 2010: using affine_transform_*
function P = pcloud_affine_transform( P, T )

P.points = affine_transform_p3( P.points, T );
if isfield( P, 'normals' )
    P.normals = affine_transform_n3( P.normals, T );
end