% internal_angle computes the internal angle at B of a triangle defined by (A, B, C)
% 
% SYNTAX
% [output] = internal_angle(M)
%
% INPUT PARAMETERS
%   A,B,C: three 3D positions
% 
% OUTPUT PARAMETERS
%   theta: the internal angle at B
%
% DESCRIPTION
%       B
%       .
%      / \             
%     / a \
%    / ~~~ \
%   /       \        
% A.         .C                 
% 
% Examples:
% this should compute an internal angle at B of 45degrees
% >> A = [ sqrt(2) sqrt(2) 0 ];
% >> B = [ 0 0 0 ];
% >> C = [ 1 0 0 ];
% >> angle = internal_angle(A, B, C)
%

% Copyright (c) 2008 Andrea Tagliasacchi
% All Rights Reserved
% email: ata2@cs.sfu.ca 
% $Revision: 1.0$  Created on: 2008/05/02
function angle = internal_angle(A, B, C)
    v1 = vector_normalize( A - B );
    v2 = vector_normalize( C - B );
    angle = abs( acos( v1*v2' ) );
    
end %end of internal_angle
