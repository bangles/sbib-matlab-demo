clc, clear all, close all;

addpath('common');
% PatchSearcher.compile();
M = mesh_read_obj('bunny.obj');
search = PatchSearcher(M);
queries = randn(100,3);
[footpoints, indixes, barycentric] = search.nn(queries);

% visualize results
hold on
h = patch(M);
set(h, 'FaceLighting', 'flat');
set(h, 'FaceColor', 'white');
myplot3(M.vertices,'.b','markersize',10);
myplot3(queries,'.r','markersize',10);
myplot3(footpoints,'.g','markersize',10);
myedge3(queries,footpoints,'b');