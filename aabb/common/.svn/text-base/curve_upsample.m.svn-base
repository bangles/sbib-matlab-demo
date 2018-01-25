% Given a curve C with subfields:
%   C.vertices 
%   C.edges
% upsamples the curve so that there are RATIO vertices 
% linearly interpolated between any vertices
function C = curve_upsample( C, RATIO ) 

% for every edge, split the edge RATIO-1 times!
for i=1:size(C.edges,1)
    
    % create points in between
    strp = C.vertices(C.edges(i,1),:);
    endp = C.vertices(C.edges(i,2),:);  
    xs = linspace(strp(1),endp(1),RATIO+2);
    ys = linspace(strp(2),endp(2),RATIO+2);
    
    % modify the first edge to point to the first created vertice
    oldendidx = C.edges(i,2);
    C.edges(i,2) = size(C.vertices,1)+1;
    
    % push vertices in data structure
    for j=1:RATIO
        C.vertices(end+1,:) = [ xs(j+1), ys(j+1) ];
        if j~=RATIO
            C.edges(end+1,:) = [size(C.vertices,1), size(C.vertices,1)+1];
        else
            C.edges(end+1,:) = [size(C.vertices,1), oldendidx];    
        end
    end   
end