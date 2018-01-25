function DST = graph_adj_to_dst(G)
% clear; load test.mat
DST = sparse( size(G.ADJ) );

% find non-zero entries of G.ADJ
[i,j] = find( G.ADJ );
for k=1:length(i)
    I = i(k);
    J = j(k);
    dst = norm( G.vertices(I,:) - G.vertices(J,:) );
    DST( I, J ) = dst;
    DST( J, I ) = dst; 
end

