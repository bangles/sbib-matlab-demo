clc, clear, close all;
mex -I/usr/local/include -I/usr/include/eigen3 -L/usr/lib/x86_64-linux-gnu -lCGAL -lboost_thread-mt -lboost_system-mt nnsearch.cpp;

M = mesh_read_obj('tet.obj'); save matlab.mat;
% load matlab.mat;

M.vertices = M.vertices-repmat( mean(M.vertices), size(M.vertices,1), 1 );

rng(0);
queries = randn(3,100);
% M.vertices = M.vertices/10;
[points, findex, barycenter] = nnsearch(M.vertices', M.faces'-1, queries);

% p = points(:,1)
% i = findex(1)
% b = barycenter(:,1)
% return;

% Visualization
if false
    addpath('/Users/andrea/Dropbox/Developer/matlibs/trilab');
    h = mesh_view(M);
    hg = getappdata(h,'hg');
    myplot3(queries','.r','markersize',10,'Parent',hg);
    myplot3(points','.g','markersize',10,'Parent',hg);
end

hold on; axis equal;
myplot3(M.vertices,'.b','markersize',10);
myplot3(queries','.r','markersize',10);
myplot3(points','.g','markersize',10);
myedge3(queries',points','b');