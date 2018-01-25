% compute the path normals
function VN = contour_normals( C )
   

% autofunction to access cyclic coordinates
N = size(C.vertices,1);
cyidx = @(i)( mod( i-1, N ) + 1 );

% allocate
VN = zeros( N, 2 );
for idx = 1:size(C.vertices,1)    
    % get current neighbor
    x1 = C.vertices( cyidx(idx-1), : );
    x2 = C.vertices( cyidx(idx+0), : );
    x3 = C.vertices( cyidx(idx+1), : );

    % compute neigboring edges normals
    v1 = x2 - x1; len1 = norm(v1);
    v2 = x3 - x2; len2 = norm(v2); 
    % perpediculars
    n1 = [v1(2), -v1(1)];
    n2 = [v2(2), -v2(1)];
    
    VN( idx,: ) = ( n1*len1 + n2*len2 ) / ( len1+len2 );
    VN( idx,: ) = VN( idx,: ) / norm( VN(idx,:) );
end
