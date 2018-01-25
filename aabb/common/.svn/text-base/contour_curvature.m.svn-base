function curv = contour_curvature( C )

% function to access contour as cyclic structure
cyidx = @(i,N)( mod( i-1, size(C.vertices,1) ) + 1 );

curv = zeros( size(C,1), 1 );
for idx = 1:size(C.vertices)    
    % 1-ring neigbours
	x1 = C.vertices( cyidx(idx-1), : );
    x2 = C.vertices( cyidx(idx),   : );
	x3 = C.vertices( cyidx(idx+1), : );
	
	v1 = x1 - x2;
	v2 = x3 - x2;
    curv(idx) = sign( det([ 1, x1;1,x2; 1,x3 ]) ) * ( 180 - acosd( dot( v1, v2 ) / (norm(v1)*norm(v2)) ) );
end	

