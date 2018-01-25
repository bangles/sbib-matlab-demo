% TURN given P, Q, does R turn on the left or the right of P,Q?
%
% SYNTAX
% t = turn(R,P,Q)
%
% INPUT PARAMETERS
%   R: [2x1] or [1x2] point location
%   P: [2x1] or [1x2] point location
%   Q: [2x1] or [1x2] point location
%
% OUTPUT PARAMETERS
%   t=1:
%   t=-1:
%   t=0: 
%
% DESCRIPTION
%
% References:
% [1] Binay Bhattacharia, "Lecture Slides", Computational Geometry, CMPT-812, FALL07
%     Simon Fraser University, Canada.

% Copyright (c) 2008 Andrea Tagliasacchi
% All Rights Reserved
% email: andrea.tagliasacchi@gmail.com
% $Revision: 1.1$  ata2: R,P,Q can be either 2x1 or 1x2
% $Revision: 1.0$  Created on: 2008/07/21
function t = isLeftTurn( R, P, Q )

turndet = det( [P(:)', 1; Q(:)', 1; R(:)', 1] );

if abs(turndet)<1e-8
    t=0; 
else
    t = sign(turndet);
end
