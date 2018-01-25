% MESH_VIEW 
% visualize a triangular mesh using "patch"
%
% SYNOPSIS
% h = myline( p, v, ... )
%   
% INPUT PARAMETERS
%   - p: a 3D set of points where to start draw the line
%   - v: a 3D set of directions in which to draw the line
%
% OUTPUT PARAMETERS
%   - h: handle to the created objects
% 
% EXAMPLE
% Draw a line from origin to corner of unit box
% >> myline( [0,0,0], [1,1,1] );
%
% SEE ALSO
% line, hgtransform
% 

% Copyright (c) 2008 Andrea Tagliasacchi
% All Rights Reserved
% email: ata2@cs.sfu.ca 
% $Revision: 1.0$  16 May. 2008: created by Andrea Tagliasacchi
% $Revision: 1.2$   3 Mar. 2009: myline => myline3
% $Revision: 1.3$  01 Oct. 2009: converted to draw a set of lines

function h = myline3( p, v, scale, varargin )  
    v = v.*scale;
    h = line( [p(:,1), p(:,1)+v(:,1)]', [p(:,2), p(:,2)+v(:,2)]', [p(:,3), p(:,3)+v(:,3)]', varargin{:} );
end
