% L2_difference vector/matrix euclidean distance
%
% SYNTAX
% 1) d = L2_difference(v1, v2) % vector vector
% 2) d = L2_difference(v1, m1) % vector matrix
% 3) d = L2_difference(m1, v1) % matrix vector
% 4) d = L2_difference(v1, v2) % matrix matrix
%
% INPUT PARAMETERS
%   m: a matrix of vectors [Nx3] (or [Nx2])
%   v: a vector of size    [1x3] (or [1x2])
%
% OUTPUT PARAMETERS
%   d: the resulting dot product 
%       1)   the euclidean distance between the two vectors
%       2,3) d(i): the euclidean distance between the vector and the i-th row of the matrix
%       4)   d(i): the euclidean distance between the i-th rows of the two matrixes
%
% DESCRIPTION
% general the euclidean distance between vector or matrixes in 2D/3D
% 
% See also:
% L2_difference_demo
%

% Copyright (c) 2008 Andrea Tagliasacchi
% All Rights Reserved
% email: ata2@cs.sfu.ca 
% $Revision: 1.0$  Created on: 2008/09/29
function D = L2_difference( v1, v2 )
    % NOTE: keep most often done first
    
    % simple 3D vectors
    if numel( v1 ) == 3 && numel( v2 ) == 3
        D = sqrt( (v1(1)-v2(1))^2 + (v1(2)-v2(2))^2 + (v1(3)-v2(3))^2 );
    % simple 2D vectors
    elseif numel( v1 ) == 2 && numel( v2 ) == 2
        D = sqrt( (v1(1)-v2(1))^2 + (v1(2)-v2(2))^2 );
    
    % 3D vector - 3D matrix (and opposite)
    elseif numel( v1 ) == 3 && size( v2, 1 ) > 1 && size( v2, 2 ) == 3
        D = vec_mat_3D( v1, v2 );
    elseif numel( v2 ) == 3 && size( v1, 1 ) > 1 && size( v1, 2 ) == 3
        D = vec_mat_3D( v2, v1 );
                
    % 2D vector - 2D matrix (and opposite)
    elseif numel( v1 ) == 2 && size( v2, 1 ) > 1 && size( v2, 2 ) == 2
        D = vec_mat_2D( v1, v2 );
    elseif numel( v2 ) == 2 && size( v1, 1 ) > 1 && size( v1, 2 ) == 2
        D = vec_mat_2D( v2, v1 );
    
    % 3D matrix - 3D matrix
    elseif size( v1, 1 ) > 1 && size( v1, 2 ) == 3 && size( v2, 1 ) > 1 && size( v2, 2 ) == 3
        D = mat_mat_3D( v1, v2 );
    
    % 2D matrix - 2D matrix
    elseif size( v1, 1 ) > 1 && size( v1, 2 ) == 2 && size( v2, 1 ) > 1 && size( v2, 2 ) == 2
        D = mat_mat_2D( v1, v2 );
    
    % error
    else
        error('The input arguments are incorrect');
    end
    
        
function D = vec_mat_2D( v, m )
    D = zeros( size(m,1), 1 );
    for i=1:size(m,1)
        D(i) = sqrt( (m(i,1)-v(1))^2 + (m(i,2)-v(2))^2 );
    end
end

function D = vec_mat_3D( v, m )
    D = zeros( size(m,1), 1 );
    for i=1:size(m,1)
        D(i) = sqrt( (m(i,1)-v(1))^2 + (m(i,2)-v(2))^2 + (m(i,3)-v(3))^2 );
    end
end

function D = mat_mat_3D( m1, m2 )
    D = zeros( size(m1,1), 1 );
    for i=1:size(m1,1)
        D(i) = sqrt( (m1(i,1)-m2(i,2))^2 + (m1(i,2)-m2(i,2))^2 + (m1(i,3)-m2(i,3))^2 );
    end
end

function D = mat_mat_2D( m1, m2 )
    D = zeros( size(m1,1), 1 );
    for i=1:size(m1,1)
        D(i) = sqrt( (m1(i,1)-m2(i,2))^2 + (m1(i,2)*m2(i,2))^2 );
    end
end

end %end of dot_product
