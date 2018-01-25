% LINE_SEGMENT_INTERSECTION: computes a line-segment intersection
% on a plane. 
%  
% SYNTAX
% [t1, t2] = line_segment_intersection( p, T, A, B )
%
% INPUT PARAMETERS
%   [p,T]: point and tangent of the line
%   [A,B]: extremities of the 2D segment
%
% OUTPUT PARAMETERS
%   t1: if an intersection exists, the value of the parameter [0,1]
%       that parametrize the segment A,B as: "P = A+(B-A)*t1"
%   t2: the ray parameter
%
% MATH DETAILS
% 
%               A
%              * 
%             /
%            /                  
% p1  *-----/---------
%          /                    
%         /                     
%        /
%       *
%      B
%       
% T'' := B-A
% T'  := T
% l1: Po' + t1*T'
% l2: Po'' + t2*T''
%
% 1) l1 == l2
% 2) Po' + t1*T' = Po'' + t2*T''
% 3) t1*T' - t2*T'' = Po' - Po''
% 4) separate x and y and write system of linear equations 
%  
% NOTE: if the segment is parallel to the ray it return the signed ray 
% distance from p1 to the closest point in direction T from p1
% 
% SEE ALSO
% example_line_segment_intersection.m
%

% Copyright (c) 2008 Andrea Tagliasacchi
% All Rights Reserved
% email: ata2@cs.sfu.ca 
% $Revision: 1.0$  Created on: 2008/05/02
function [t1, t2] = line_segment_intersection( p, T, A, B  )

TH_ZERO = 1e-10;

v1 = [ T(1); T(2) ];
v2 = [ -(B(1)-A(1)); -(B(2)-A(2)) ]; 
TMAT = [ v1, v2 ]; % ovverrides the meaning of T
P = [ A(1)-p(1); A(2)-p(2) ];

% if the two lines are not parallel, which 
% also implies not linearly independent columns
% and thus not full rank matrix
if abs( det(TMAT) ) > TH_ZERO
   t12 = TMAT\P;
   % return parametrization on the second segment
   t1 = t12(2);
   t2 = t12(1);
else
    % line is parallel here... but is it overlapped or not?
    % if one of the points is aligned with T yes.. (since
    % the other one will be implicitly aligned
    
    % they are aligned, return a ray t that parametrize the
    % first vertice reached
    if norm( cross( [P(1),P(2),0], [T(1),T(2),0] ) ) < TH_ZERO
        t2a = norm(p-A) * sign( dot(A-p,T) );
        t2b = norm(p-B) * sign( dot(B-p,T) );
        t2 = min( t2a, t2b );
        t1 = nan;
        
    % they are not aligned, just parallel
    else
        t1 = nan;
        t2 = nan;
    end
end %end of line_segment_intersection
