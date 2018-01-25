% Computes the laplacian matrix of a mesh M
% requires: {M.faces, M.vertices}
% Also check out laplacian_solve
function L = mesh_laplacian( M, TYPE, eps )
if nargin==1, TYPE='fujiwara'; end

% create SPARSE adjacency matrix
nv = size(M.vertices,1);
% L = sparse( nv,nv );
L = spalloc( nv,nv,6*nv ); %average 6 non-zero per column 

if strcmp(TYPE,'fujiwara')
   % check out "sparse" and "spalloc" to see how to 
   % efficiently allocate
   rowsum = zeros( nv, 1 );
   for i=1:size(M.faces,1)
      v1i = M.faces(i,1); v1 = M.vertices(v1i,:);
      v2i = M.faces(i,2); v2 = M.vertices(v2i,:);
      v3i = M.faces(i,3); v3 = M.vertices(v3i,:);
      
      %edge 1
      edge1 = norm( v1 - v2 );
      L( v1i, v2i ) = edge1;
      L( v2i, v1i ) = edge1;
      rowsum(v1i) = rowsum(v1i)+edge1;
      rowsum(v2i) = rowsum(v2i)+edge1;
      %edge 2
      edge2 = norm( v2 - v3 );
      L( v2i, v3i ) = edge2;
      L( v3i, v2i ) = edge2;
      rowsum(v2i) = rowsum(v2i)+edge2;
      rowsum(v3i) = rowsum(v3i)+edge2;
      %edge 3
      edge3 = norm( v1 - v3 );
      L( v1i, v3i ) = edge3;
      L( v3i, v1i ) = edge3;
      rowsum(v1i) = rowsum(v1i)+edge3;
      rowsum(v3i) = rowsum(v3i)+edge3;
   end
   % manifold, every edge scanned twice
   rowsum = rowsum / 2;
   
   %--- Fill diagonal
   for j=1:nv
%       if sum( L(j,:) ) ~= rowsum(j)
%          disp(sum(L(j,:)));
%          disp(rowsum(j));
%          error('here');
%       end
       
      %--- Slow...
      % L(j,j) = -sum( L(j,:) ); 
      %--- Quite fast!!
      L(j,j) = -rowsum( j );       
   end
   
   
elseif strcmp(TYPE,'invedgelength')
    assert( nargin==3, 'e.g. eps=1e-8');
    
    % avoids divide by zero
    eps = 1e-8;
    
    % check out "sparse" and "spalloc" to see how to 
    % efficiently allocate
    rowsum = zeros( nv, 1 );
    for i=1:size(M.faces,1)
        v1i = M.faces(i,1); v1 = M.vertices(v1i,:);
        v2i = M.faces(i,2); v2 = M.vertices(v2i,:);
        v3i = M.faces(i,3); v3 = M.vertices(v3i,:);
                
        %edge 1
        edge1 = 1 / ( eps + norm( v1 - v2 ) );
        L( v1i, v2i ) = edge1;
        L( v2i, v1i ) = edge1;
        rowsum(v1i) = rowsum(v1i) + edge1;
        rowsum(v2i) = rowsum(v2i) + edge1;
        %edge 2
        edge2 = 1 / ( eps + norm( v2 - v3 ) );
        L( v2i, v3i ) = edge2;
        L( v3i, v2i ) = edge2;
        rowsum(v2i) = rowsum(v2i)+edge2;
        rowsum(v3i) = rowsum(v3i)+edge2;
        %edge 3
        edge3 = 1 / ( eps + norm( v1 - v3 ) );
        L( v1i, v3i ) = edge3;
        L( v3i, v1i ) = edge3;
        rowsum(v1i) = rowsum(v1i)+edge3;
        rowsum(v3i) = rowsum(v3i)+edge3;
   end
   % manifold, every edge scanned twice
   rowsum = rowsum / 2;
   for j=1:nv
      L(j,j) = -rowsum( j );       
   end
   
elseif  strcmp(TYPE,'combinatorial')
   for i=1:size(M.faces,1)
      v1i = M.faces(i,1);
      v2i = M.faces(i,2);
      v3i = M.faces(i,3);
      
      %edge 1
      L( v1i, v2i ) = 1;
      L( v2i, v1i ) = 1;
      %edge 2
      L( v2i, v3i ) = 1;
      L( v3i, v2i ) = 1;
      %edge 3
      L( v1i, v3i ) = 1;
      L( v3i, v1i ) = 1;      
   end
   %--- Fill diagonal
   for j=1:nv
      L(j,j) = -sum( L(j,:) ); 
   end
end