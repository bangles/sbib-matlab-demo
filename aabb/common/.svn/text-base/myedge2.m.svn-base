% nyedge: draws a 3D edge specified by two 3D points
%
% SYNTAX
% h = myedge( p1, p2, ... )
%
% OUTPUT PARAMETERS
%   h: handler to created object
%
% DESCRIPTION
% this has been developed out of frustration because the matlab "line"
% works with a weird parameter set that makes it horrible to program
%
% See also:
% PLOT

% Copyright (c) 2008 Andrea Tagliasacchi
% All Rights Reserved
% email: ata2@cs.sfu.ca 
% $Revision: 1.0$  Created on: 2008/05/28
function h = myedge2( p1, p2, varargin )

% the transpose are for when A,B are matrixes
% where every row is a point
A = [p1(:,1), p2(:,1)]';
B = [p1(:,2), p2(:,2)]';
h = plot( A, B, varargin{:} );
