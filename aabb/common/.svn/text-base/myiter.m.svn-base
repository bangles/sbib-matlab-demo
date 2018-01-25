% returns an iterator for A
% if A is a [KxNx...] returns 
% an index which spans 1:k
function I = myiter( A )

if length(size(A))>1
    I = 1:size(A,1);
else
    error('no other iterator defined');
end