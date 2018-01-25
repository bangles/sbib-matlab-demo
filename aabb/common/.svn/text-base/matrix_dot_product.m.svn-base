% TODO: calculates the dot product between a 3D vector
% and a matrix of 3D vectors in 3xN form

% alternatively something with arrayfun can be used:
% arrayfun(@(idx) dot(TheMatrix(idx,:)), 1:size(TheMatrix,1))
function [ D ] = matrix_dot_product( v, M )
    v = v(:); %make a column
    D = zeros( size(M,1), 1 );
    for i=1:size(M,1)
       D(i) = M(i,:)*v; 
    end 
end