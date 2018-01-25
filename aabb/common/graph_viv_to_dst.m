% Converts a cell array which contains a one ring of neighboring vertex indices 
% VERTEX INCIDENT VERTICES a.k.a. VIV
%
% for each graph vertex into an adjecency matrix where nonzero
% elements indicate euclidean edge distances
% 
% G:
%   - v: thin matrix of graph vertices embedded in R^n
%   - viv: cell matrix of neighboring vertices
function DST = graph_viv_to_dst( G )
v   = G.vertices;
viv = G.viv;
DST = sparse( size(v,1), size(v,1) );
for j=1:size( v,1 )
    currv = v(j,:);
    neighs = viv{j};
    for n=1:numel(neighs)
        currn = v(neighs(n),:);
        dst = norm( currv - currn );
        DST( j,neighs(n) ) = dst;
        DST( neighs(n),j ) = dst;       
    end
end