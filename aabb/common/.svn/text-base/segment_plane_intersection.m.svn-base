% SEGMENT_PLANE_INTERSECTION
%
% SYNTAX
% t = segment_plane_intersection(P0,P1,Pp,n)
%
% INPUT PARAMETERS
%   - n: normal of plane
%   - Pp: reference point of the plane
%   - P1,P0: extremities of the segment
%
% OUTPUT PARAMETERS
%   t: value in [0,1] if an intersection is found,
%      empty [] if an intersection is not found
%
% DESCRIPTION
%
% computes the intersection of a semgment and a plane
% describing the solution in the segment parameter space.
%
% 
% The two geometric locuses are described by:
%
% Segment: x = P0 + t(P1-P0)
% Plane: <(x-Pp), n> = 0
%
% Substituting the first into the second and solving
% we get:
% 
% t = (Pp*n' -P0*n') / ( (P1-P0)*n' )
% 
% See also:
% example_segment_plane_intersection
%

% Copyright (c) 2008 Andrea Tagliasacchi
% All Rights Reserved
% email: ata2@cs.sfu.ca 
% $Revision: 1.0$  Created on: 2008/07/03
function t = segment_plane_intersection(P0,P1,Pp,Np)
    t = ( Pp*Np' -P0*Np' ) / ( (P1-P0)*Np' );
    % note: denominator == 0 if they are parallel
    % note: if den==0 => numerator==0 if they are lying together 
end %end of segment_plane_intersection
