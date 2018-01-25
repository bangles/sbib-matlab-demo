function [Pmin, Pmax] = curve_bbox(C)
    Pmin = min( C.vertices );
    Pmax = max( C.vertices );
end