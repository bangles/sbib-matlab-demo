clc, clear, close all;

% % generate some random points
% P = struct();
% P.points = rand(100,3)-.5;
% 
% selection = 1258;
% M = mesh_read_smf('homer.smf');
% M.vertices = mesh_normalize( M );
% M.VIF = mesh_compute_vertex_incident_faces( M );
% M.VIV = mesh_compute_vertex_incident_vertices( M );
% M.PWD = mesh_compute_pairwise_distances( M, selection );
% M.FN = mesh_compute_face_normals(M);
% M.FA = mesh_compute_face_areas(M);
% M.VN = mesh_compute_vertex_normals( M );
% M.FIF = mesh_compute_face_incident_faces(M);
% MAP = colormap('jet');
% close all;
% M.PWD{selection} = M.PWD{selection}/max(M.PWD{selection});
% M.FaceVertexCData = zeros( size(M.PWD{selection},1), 3 );
% for vIdx=1:size(M.FaceVertexCData,1)
%     M.FaceVertexCData(vIdx,:) = MAP( round(M.PWD{selection}(vIdx)*(size(MAP,1)-1))+1, : ).^2;
% end
load;

% create a set of polylines
CUTS = mesh_cut( M, [0,-.01,0], [0,1,1] );

%%% RENDER
fid = pbrt_render('init', 'example', 'resolution', [1024, 1024]);
pbrt_render('mesh', fid, M );
pbrt_render('polyline', fid, CUTS{1});
pbrt_render('pcloud', fid, P);
pbrt_render('end',fid);
pbrt_render('render','example');