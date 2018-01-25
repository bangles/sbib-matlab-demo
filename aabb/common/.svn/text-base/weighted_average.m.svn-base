% given a set of N points in k dimensions computes
% the weighted average of the points in the set
function avg = weighted_average( p, w )
avg = zeros( size(p,2), 1 );

if length(w) ~= size(p,1) 
    error('weights must be the same cardinality as points')
end 

normalfact = sum( w );
% for 
for k=1:size(p,2)
    avg(k) = sum( p(:,k).*w(:) ) / normalfact;
end