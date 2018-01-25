function verts = contour_normalize( C )
   
% compress the vertices of all curves in a single structure
% and compute range data (note [] are ESSENTIAL)
mn = min( vertcat(C.vertices) );
mx = max( vertcat(C.vertices) );
range = max(mx - mn);
half_range = range/2;
cnst = (mx - mn)/2;

verts = zeros( size(C.vertices) );
for vIdx = 1:size(C.vertices)
    verts(vIdx,:) = (C.vertices(vIdx, :) - mn - cnst)/half_range;
end
