clc, clear, close all;

%--- Read the data
M = mesh_read_obj('mesh_scan_demo.obj');
hg = getappdata( mesh_view( M ), 'hg' );

%--- The precision of the scanner
delta = 0.05;

%--- The view direction (as affine transformation)
% T = eye(4,4);

%--- The view direction using "view point"
viewdir = [1 0 0];
T = create_orthonormal_frame( viewdir );
T(1,:) = T(3,:);
T(3,:) = viewdir;
T(4,4) = 1;

%--- Perform the scan, save in ply format as 
% meshlab imports OBJ normals incorrectly
P = mesh_scan(M,T,delta, 1);
pcloud_write_ply( P, 'mesh_scan_demo.pcloud.ply' );

%--- Visualize
mypoint3( P.points, '.r', 'parent', hg );