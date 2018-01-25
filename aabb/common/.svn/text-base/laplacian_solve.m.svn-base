function sol = laplacian_solve(L,c,omega)

%--- Dim checks
assert( size(L,1)==size(L,2) );
assert( size(c,1)==size(L,1) );
assert( size(c,2)==1 );
nv = size(L,1);
% nc = sum(1-isnan(c));

% Modified not to include c=0
nc = sum(1-isnan(c)-(omega==0));

%--- Vectorize weights
if isscalar(omega)
    omega = omega * ones(nc,1);
end

%--- Change dimensions of L
L(nv+nc,1)=0;

%--- Allocate space for constraints
% first nv entries will stay zero
b = zeros(nv+nc,1);

%--- Insert weight & values entries
I = find(~isnan(c)&~(omega==0) );
for j=1:nc
    L(nv+j, I(j)) = omega( I(j) );
    b(nv+j      ) = omega( I(j) ) * c( I(j) );
end
   
%--- SOLVE the sparse linear system
sol = L \ b;
% sol = linsolve(L,b); %NOT WORK ON SPARSE


% DEBUG CHUNK
% N = find( L(2257,:) );
% N(N==2257) = [];
% coeff = nonzeros( L(2257,N) );
% res = - (c(N)'*coeff) / L(2257,2257)
% sol( 2257 )