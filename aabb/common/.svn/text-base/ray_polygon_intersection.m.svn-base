% given a generic planar polygon computes the 
% ray-polygon intersection. Polygon is a Nx2 set of samples
% with cyclic indexing (no repeated last element)
%
% WRITTEN 1 March 2010
function ray_t = ray_polygon_intersection( ray_p, ray_n, polygon )
DEBUG_MODE = 0;
if DEBUG_MODE
    clc, clear, close all;
    load ray_polygon_intersection.mat ray_p ray_n polygon
    figure(1), hold on;
    mypoint2( polygon );
    mypoint2( ray_p, '*b');
end

% scan whole polygon and keep closest intersection
ray_t = inf;
for i=1:size(polygon,1)
    A = polygon(i,:);
    if i<size(polygon,1)
        B = polygon(i+1,:);
    else
        B = polygon(1,:);
    end
    [edget, curr_ray_t] = line_segment_intersection( ray_p, ray_n, A, B );
    
    if edget>=0 && edget<=1 && curr_ray_t>0
        if DEBUG_MODE, mypoint2( ray_p+ray_n*curr_ray_t,'*r'); end
        if curr_ray_t < ray_t, ray_t = curr_ray_t; end
    end    
end

if DEBUG_MODE,
    myline2( ray_p, ray_n, ray_t );
end