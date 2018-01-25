clc, clear, close all;
M = mesh_read_obj('egg.obj');
% M = mesh_read_obj('sphere.obj');
% 
% M.vertices = mesh_normalize( M );
% M.VIF = mesh_vertex_incident_faces( M );
% M.VIV = mesh_vertex_incident_vertices( M );
% [ M.FIF, M.FOV ] = mesh_face_incident_faces( M, 'sorted' );
% M = mesh_subdivide( M, 'loop' );

% L = mesh_laplacian(M,'combinatorial');
L = mesh_laplacian(M,'combinatorial');


IPOS = ( M.vertices(:,2)>0 );
M.FaceVertexCData = double(IPOS);
figure, mesh_view(M);

M.vertices(IPOS,2) = 0;

OMEGA = 1e10*(1-double(IPOS));
M.vertices(:,1) = laplacian_solve(L,M.vertices(:,1),OMEGA);
M.vertices(:,2) = laplacian_solve(L,M.vertices(:,2),OMEGA);
M.vertices(:,3) = laplacian_solve(L,M.vertices(:,3),OMEGA);

figure, mesh_view(M);
return