% [ Copyright (c) 2007 Andrea Tagliasacchi - ata2 at cs dot sfu dot ca - All rights reserved ]
%
% SYNOPSIS
%	- D = norm3( A, B )
%     D = norm3( A )
%
% DESCRIPTION
%	- This function computes the euclidean distance 
%     between two points in the space
% 
% INPUT
%   - A: the first point coordinate
%   - B: the second point coordinate
%
% OUTPUT
%   - D: the euclidean distance between A and B
% 
% NOTES
% 1) D = sqrt( sum( (A-B).^2, 2 ) ) ;
% 2) D = sqrt( (A(:,1)-B(:,1))^2 + (A(:,2)-B(:,2))^2 + (A(:,3)-B(:,3))^2 ) ;
% 
% These were the timing of the two proposals on a 10000 distances computation:
% Elapsed time is 0.207055 seconds.
% Elapsed time is 0.153488 seconds.
%
% Ergo the second is the choosen one now
%
% But the first formulation adapts better to matrix notation!!
function D = norm3( A, B )
assert( size(A,2)==3 );

if nargin==1
    D = sqrt( sum( (A).^2, 2 ) ) ;
else
    assert( size(B,2)==3 );
    D = sqrt( sum( (A-B).^2, 2 ) ) ;    
end