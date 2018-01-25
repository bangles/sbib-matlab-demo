function edges = mesh_edges(M)

% assumes manifold and faces oriented uniformly
edges = [M.faces(:,[1,2]); M.faces(:,[2,3]); M.faces(:,[3,1])];
% make ADJ upper triangular
edges = sort( edges,2 );
% extract vertices from matrix
v1Idxs = edges(:,1);
v2Idxs = edges(:,2);
% construct ADJ sparse matrix
nnzeros = size(edges,1);
nverts = size(M.vertices,1);
ADJ = sparse( v1Idxs, v2Idxs, ones(size(edges,1),1), nverts, nverts, nnzeros);
% find non-zero indexes
[ii,jj] = find(ADJ);
edges = [ii,jj];