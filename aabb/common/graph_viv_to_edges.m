% convert a one-ring neighborhood structure (viv) in an edge structure
% no particular direction on the edges is ensured
%
% G is a graph with a viv field
% edges is a Nx2 matrix of edge indexes
% this also outputs an ADJ matrix as a side product

% Created ata2: Feb 2010.
function [edges, ADJ] = graph_viv_to_edges(G)

viv = G.viv;
ADJ = sparse( size(viv,1), size(viv,1) );
edges = zeros(0,2);

% add an edge if and only if the corresponding 
% pair of vertices has never been visited
for fr_idx=1:length(viv)
    curr_ns = viv{fr_idx};
    
    for to_idx=curr_ns(:)'
        if ~ADJ(fr_idx,to_idx) 
            edges(end+1,:) = [fr_idx,to_idx]; %#ok<AGROW>
            ADJ(fr_idx,to_idx) = 1;
            ADJ(to_idx,fr_idx) = 1;
        end
    end    
end
