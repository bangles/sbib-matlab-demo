% given a adjecency matrix ADJ (possibly sparse)
% it computes the corresponding edge set (undirected)
function ADJ = graph_edges_to_adj( G )

ADJ = sparse( size(G.edges,1),size(G.edges,1) );
for eIdx=1:length(G.edges)
    e1 = G.edges(eIdx,1);
    e2 = G.edges(eIdx,2);
    
    ADJ(e1,e2) = 1;
    ADJ(e2,e1) = 1;
    % disp( full(ADJ) );
end
