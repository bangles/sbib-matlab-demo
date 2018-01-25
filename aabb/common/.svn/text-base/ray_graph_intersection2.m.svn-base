% given a generic planar graph, computes the 
% ray-graph intersection. Graph is a curvegraph data structure
%
% WRITTEN 5 March 2010
function ray_t = ray_graph_intersection2( ray_p, ray_n, CG )
DEBUG_MODE = 0;
if DEBUG_MODE
    warning('debug mode enabled'); %#ok<UNRCH>
    clc, close all;
    load ray_graph_intersection2.mat CG
    ray_p = [50,50];
    ray_n = [1, 0];
    
    figure(1), hold on;
    mygraph2( CG );
    mypoint2( ray_p, '*b');
end

% scan whole polygon and keep closest intersection
ray_t = inf;
for i=1:size(CG.edges,1)
    A = CG.vertices( CG.edges(i,1), : );
    B = CG.vertices( CG.edges(i,2), : );
    [edget, curr_ray_t] = line_segment_intersection( ray_p, ray_n, A, B );
    
    if edget>=0 && edget<=1 && curr_ray_t>0
        if DEBUG_MODE 
            mypoint2( ray_p+ray_n*curr_ray_t,'*r'); 
        end %#ok<UNRCH>
        if curr_ray_t < ray_t, ray_t = curr_ray_t; end
    end
end

if DEBUG_MODE,
    myline2( ray_p, ray_n, ray_t ); %#ok<UNRCH>
end