% mydedge3: draws a 3D directed edge specified by two 3D points A,B
% the arrows are created with quiver3
%
% SYNTAX
% h = mydedge3( A,B, ... )
%
% OUTPUT PARAMETERS
%   h: handler to created object
%
% See also:
% quiver3

% Copyright (c) 2009 Andrea Tagliasacchi
% All Rights Reserved
% email: andrea.tagliasacchi@gmail.com
% $Revision: 1.0$  Created on: 2009/09/27
function h = mydedge3( A, B, varargin )
    P = A;
    V = B-A;
    h = quiver3( P(:,1), P(:,2), P(:,3), V(:,1), V(:,2), V(:,3), varargin{:} );

