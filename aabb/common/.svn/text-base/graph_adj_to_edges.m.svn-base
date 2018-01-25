% given a adjecency matrix ADJ (possibly sparse)
% it computes the corresponding edge set (undirected)
function edges = graph_adj_to_edges( ADJ )

edges = zeros( 0,2 );

for i=1:size(ADJ,1)
    for j=i+1:size(ADJ,2)
        if ADJ(i,j)>0
            edges(end+1,:) = [i,j]; %#ok<AGROW>
        end
    end
end
