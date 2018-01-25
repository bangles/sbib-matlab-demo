% L2 MUST be a bi-laplacian matrix or this will simply fail
function newfield = bilaplacian_solve(L2,field,omegas)
assert( size(omegas,2) == 1 );
assert( size(field,2) == 1 );    
nv = size(L2,1);

%--- Create diagonal weight matrix
P = spdiags(omegas, 0, nv, nv); 
% P = speye(nv,nv).*omegas;

%--- Create RHS
b = P*field;
%--- Pseudo inverse is bi-laplacian
L2 = L2+P;
newfield = L2 \ b;
