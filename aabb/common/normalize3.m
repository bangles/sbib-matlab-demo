% assumes every row is a 3D vector
% normalizes every vector to have 1 norm
% can also used passed normalization vector
function A = normalize3(A, nrm)
assert( size(A,2)==3 );

if nargin==1
    nrm = norm3( A );
end
assert(all(nrm>0),'normalize3 error');

% Apply normalization
A(:,1) = A(:,1) ./ nrm;
A(:,2) = A(:,2) ./ nrm;
A(:,3) = A(:,3) ./ nrm;