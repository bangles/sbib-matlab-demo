% SCALAR_PRODUCT vector/matrix scalar product
%
% SYNTAX
% 1) V = dot_product(c, v) % scalar vector
% 2) M = dot_product(c, m) % scalar matrix
%
% INPUT PARAMETERS
%   c: a scalar value
%   m: a matrix of vectors [Nx3] (or [Nx2])
%   v: a vector of size    [1x3] (or [1x2])
%
% OUTPUT PARAMETERS
%   d: the resulting scaled vector or matrix
%       1) the scalar product of v with the vector v
%       2) in i-th row, the scalar product of a(i) with 
%          the i-th row of the matrix
%       
% DESCRIPTION
% general scalar product between scalar and vector or matrixes in 2D/3D
% 
% See also:
% SCALAR_PRODUCT_DEMO
%

% Copyright (c) 2008 Andrea Tagliasacchi
% All Rights Reserved
% email: ata2@cs.sfu.ca 
% $Revision: 1.0$  Created on: 2008/09/26
function RET = scalar_product( a, v )

% scalar - 2D/3D matrix
if size( v, 1 ) >= 1 && ( size( v, 2 ) == 3 || size( v,2 ) == 2 )
    if numel(a) ~= size(v,1)
        error('a must be a vector containing an entry for every row of v');
    end
    
    RET = v;
    for i=1:size(v,1)
       RET(i,:) = a(i).*v(i,:); 
    end  
    
% error
else
    error('The input arguments are incorrect scalar has size: %d, vector/matrix has size: %d %d', numel(a), size(v,1), size(v,2) );
end