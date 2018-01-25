function P0 = contour_weighted_centroid( C )

% add padding to close the loop
V = [ C.vertices; C.vertices(1,:) ];

tot_centr = [0,0];
tot_weigh = 0;

for i=1:size( C.vertices,1 )
    vCurr = V(i,:);
    vNext = V(i+1,:);
    centr = (vCurr+vNext)/2;
    
    weigh = norm( vCurr - vNext );
    tot_centr = tot_centr + centr*weigh;
    tot_weigh = tot_weigh + weigh;
end

P0 = tot_centr / tot_weigh;