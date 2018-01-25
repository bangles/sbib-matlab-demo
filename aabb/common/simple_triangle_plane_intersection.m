% TRIANGLE_PLANE_INTERSECTION short description
%
% SYNTAX
% [output] = triangle_plane_intersection(M)
%
% INPUT PARAMETERS
%   M: mesh in patch format with the following additional subfields
%       - M.FA:
%       - M.FN:
%
% OUTPUT PARAMETERS
%   output: output description
%
% DESCRIPTION
% intersect a plane with a triangle and returns the two
% resulting intersecting segments.
%
% See also:
% example_triangle_plane_intersection, segment_plane_intersection
%

% Copyright (c) 2008 Andrea Tagliasacchi
% All Rights Reserved
% email: ata2@cs.sfu.ca 
% $Revision: 1.0$  Created on: 2008/07/03
function [P, IDX] = simple_triangle_plane_intersection(V, Pp, Np)
   
    % initialize
    P   = zeros(0,3);
    IDX = zeros(0,1);
    
    % try intersect every of the three edges with the plane
    p0 = V( 1, : );
    p1 = V( 2, : );
    p2 = V( 3, : );
    
    t = segment_plane_intersection(p0,p1,Pp,Np);
    if t >= 0 && t <= 1
        P(end+1,:)   = p0 + t*(p1-p0);
        IDX(end+1) = 3;
    end

    t = segment_plane_intersection(p1,p2,Pp,Np);
    if t >= 0 && t <= 1
        P(end+1,:)   = p1 + t*(p2-p1);
        IDX(end+1) = 1;
    end
    
    t = segment_plane_intersection(p2,p0,Pp,Np);
    if t >= 0 && t <= 1
        P(end+1,:)   = p2 + t*(p0-p2);
        IDX(end+1) = 2;
    end
end %end of triangle_plane_intersection
