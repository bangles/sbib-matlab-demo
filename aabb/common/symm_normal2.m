function vsymm = symm_normal2(V)


% construct the quadratic form matrix
N = size( V, 1 );
Vxx = sum(V(:,1).^2)/N - sum(V(:,1))^2/N^2; 
Vyy = sum(V(:,2).^2)/N - sum(V(:,2))^2/N^2;
Vxy = 1/N*sum(V(:,1).*V(:,2)) - 1/N^2*sum(V(:,1))*sum(V(:,2)); Vyx = Vxy;
M = [ Vxx Vxy; Vyx Vyy ];
[vec, lam] = svd( M );

% extract eigenvector of smallest eigenvalue
[IGN, IDX] = min( [lam(1,1), lam(2,2) ] );
vsymm = vec(:,IDX);


%--- visualize spokes
% clf, myline2( zeros( size(V,1), 2 ), V, 1 );
% line( [0,+vsymm(1)], [0,+vsymm(2)], 'linewidth', 5 );
% line( [-vsymm(1),0], [-vsymm(2),0], 'linewidth', 5 );