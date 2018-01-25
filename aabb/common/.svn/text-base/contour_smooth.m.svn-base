% TODO: this does not take into account of vertex distance..
function output = contour_smooth( C, W )

if ~exist('W','var')
    W = gausswin( 5 );
end

% index access
cyidx = @(i,N)( mod( i-1, N ) + 1 );

M = length(W);  
iCurr = ceil( M/2 ); %index of center element
N = size(C.vertices, 1);
output = zeros(N,2);

% for every point
for i=1:size(C.vertices, 1)
    neigh = zeros(M,2);
    for j=1:M
        neigh(j,:) = C.vertices( cyidx( i-iCurr+j, N ), : );
    end;

    output(i, :) = sum( neigh .* [W,W] ) / sum( W );         
end
