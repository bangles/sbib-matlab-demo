% converts data structure like the one outputted by voronoin 
% into a vertex adjecency cell array
%
% Active flags need to be provided.. Which vertices are to be
% kept while constructing the adjecency matrix? Other connections
% (vertex with flag=0) will be discarded.
% 
% EXAMPLE:
% [v,CELLS] = voronoin( vor_in );
% VIV = graph_poly_to_viv( CELLS, ones( size(v,1),1 ) );
%
% Created on 10th May 2010
function VIV = graph_poly_to_viv( poly, flags )

VIV = cell( size(flags,1),1 );
for i=1:length(poly)
    
    % cyclic indexing cycle
    K = [2:length(poly{i}),1];
    for j=1:length(poly{i})
        idx1 = poly{i}(j);
        idx2 = poly{i}(K(j));
        %--- if both active
        if flags(idx1) && flags(idx2)
            VIV{idx1} = union( VIV{idx1}, idx2 );
            VIV{idx2} = union( VIV{idx2}, idx1 );
        end      
    end
end