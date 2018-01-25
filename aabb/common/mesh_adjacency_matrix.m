% MESH_ADJACENCY_MATRIX
% computes the adjacency matrix of a mesh
%
% SYNOPSIS
% ADJ = mesh_adjacency_matrix( M )
%
% INPUT PARAMETERS
%   - M: Patch structure
%
% OUTPUT PARAMETERS
%   - ADJ: sparse matrix containing adjacency information.
%
% DESCRIPTION
% ADJ is a sparse matrix where ADJ(i,j) is 1 if vertex i 
% is connected to vertex i
% 
% EXAMPLE
% Displays the area of the first face of the mesh
% >> M = mesh_read_off('rabbit.off');
% >> M.ADJ = mesh_adjacency_matrix( M );
% >> disp('incident vertices of vertex 1: ');
% >> disp( find( M.ADJ(1,:) == 1 ) );
%
function ADJ = mesh_adjacency_matrix( M )

% create SPARSE adjacency matrix
ADJ = sparse( size(M.vertices,1),size(M.vertices,1) ); 

% check out "sparse" and "spalloc" to see how to 
% efficiently allocate
for i=1:size(M.faces,1)
    %edge 1
    ADJ( M.faces(i,1), M.faces(i,2) ) = 1;
    ADJ( M.faces(i,2), M.faces(i,1) ) = 1;
    %edge 2
    ADJ( M.faces(i,2), M.faces(i,3) ) = 1;
    ADJ( M.faces(i,3), M.faces(i,2) ) = 1;
    %edge 3
    ADJ( M.faces(i,1), M.faces(i,3) ) = 1;
    ADJ( M.faces(i,3), M.faces(i,1) ) = 1;
end;

