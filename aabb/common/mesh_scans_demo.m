%--- Read the data
filename = 'mesh_scan_demo';
M = mesh_read_obj([filename,'.obj']);
hg = getappdata( mesh_view( M ), 'hgtransform' );

%--- The precision of the scanner
delta = 0.05;

%--- The view direction (as affine transformation)
% T = eye(4,4);

%--- The view direction using "view point"
viewdirs = [ 0  0  1;  0  0 -1; % z
             1  0  0; -1  0  0; % x
             0  1  0;  0 -1  0; % y
             1  1  1;  1  1 -1; 
             1 -1  1;  1 -1 -1; 
            -1  1  1; -1  1 -1; 
            -1 -1  1; -1 -1 -1; ];

P.points  = zeros(0,3);
P.normals = zeros(0,3);
for i=1:size(viewdirs,1)
    viewdir = viewdirs(i,:)/norm(viewdirs(i,:));
    T = create_orthonormal_frame( viewdir );
    T(1,:) = T(3,:);
    T(3,:) = viewdir;
    T(4,4) = 1;

    %--- Perform the scan, save in ply format as 
    % meshlab imports OBJ normals incorrectly
    P_new = mesh_scan(M,T,delta, 1);
    
    %--- Visualize
    mypoint3( P_new.points, '.r', 'parent', hg );

    %--- Concatenate
    P.points  = [P.points;  P_new.points ];
    P.normals = [P.normals; P_new.normals];
    
    %--- Save (progressively)
    pcloud_write_ply( P, [filename,'.pcloud.obj'] );
end