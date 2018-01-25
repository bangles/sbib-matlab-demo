% MESH_SCAN
%
% simulates a range scan of
% - mesh M
% - from view T
% - with sampling grid of size delta
% 
% The point set is returned in OBJECT coordinates (already registered)
%
function P = mesh_scan( M, T, delta, isaccelerated )

%--- DEFUALT
if ~exist('isaccelerated', 'var')
    isaccelerated = 0;
end

%--- Apply viewpoint transformation T
M = mesh_affine_transform( M, T );

%--- create sampling grid
xs = min(M.vertices(:,1)):delta:max(M.vertices(:,1));
ys = min(M.vertices(:,2)):delta:max(M.vertices(:,2));

Z_ori = 2; % this is ensured to be out of bounding box
P.points  = zeros(0,3);
P.normals = zeros(0,3);

%--- SCAN
if isaccelerated
    maxL = mesh_max_edge_length( M ) / 2;
    kdtree = kdtree_build( M.vertices );
    M.VIF = mesh_vertex_incident_faces( M );
end    
% iterate through every scan point
h = txtwaitbar('init', 'Scanning');
for xi=1:length(xs)
    for yi=1:length(ys)
        h = txtwaitbar(((xi-1)*length(ys)+yi)/(length(ys)*length(xs)), h);
        ray_P1 = [ xs(xi), ys(yi),  Z_ori ];
        ray_P2 = [ xs(xi), ys(yi), -Z_ori ];
        
        % do ray triangle intersection and keep track of the closest intersection
        tmin = inf;
        faceidx = 0;
        
        %--- Accelerated search
        if isaccelerated
            querybox = [ ray_P1(1)-maxL, ray_P1(1)+maxL; 
                         ray_P1(2)-maxL, ray_P1(2)+maxL; 
                                 -Z_ori,         Z_ori   ];
            vidxs = kdtree_range_query(kdtree, querybox );
            for v=1:length(vidxs)
                fidxs = M.VIF{vidxs(v)};
                for k=1:length(fidxs)
                    tri_v1 = M.vertices(M.faces(fidxs(k),1),:);
                    tri_v2 = M.vertices(M.faces(fidxs(k),2),:);
                    tri_v3 = M.vertices(M.faces(fidxs(k),3),:);
                    [intersectP t] = ray_triangle_intersection( ray_P1, ray_P2-ray_P1, tri_v1, tri_v2, tri_v3 );
                    % keep closest ray-triangle intersection
                    if intersectP && tmin > t
                        tmin = t;
                        faceidx = fidxs(k);
                    end
                end      
            end
        else
            for fIdx=1:size(M.faces,1)
                tri_v1 = M.vertices(M.faces(fIdx,1),:);
                tri_v2 = M.vertices(M.faces(fIdx,2),:);
                tri_v3 = M.vertices(M.faces(fIdx,3),:);
                [intersectP t] = ray_triangle_intersection( ray_P1, ray_P2-ray_P1, tri_v1, tri_v2, tri_v3 );
                % keep closest ray-triangle intersection
                if intersectP && tmin > t
                    tmin = t;
                    faceidx = fIdx;
                end
            end
        end
        
        
        % reconstruct sample and add to output (if intersected something)
        % also recover its normal from face normal % don't interpolate normals
        if ~isinf(tmin)
            P.points (end+1,:) = ray_P1 + (ray_P2-ray_P1)*tmin;
            P.normals(end+1,:) = triangle_normal(faceidx);
        end
    end
end
txtwaitbar('close',h);

if isaccelerated
    kdtree_delete(kdtree);
end


%--- invert the affine transform so that samples
% are perfectly aligned with the shape
P = pcloud_affine_transform( P, T' );

%--- computes the maximum length of any edge of any face of the mesh
function maxdist = mesh_max_edge_length(M)
    maxdist = 0;
    for i=1:length(M.faces)
        I = [1 2 3 1];
        currvs = M.vertices(M.faces(i,:),:);
        for j=1:length(I)-1
            currd = euclidean_distance( currvs(I(j),:), currvs(I(j+1),:) );
            maxdist = max( maxdist, currd );        
        end   
    end
end

%--- computes the triangle normal and re-orient it to face scanner
function N = triangle_normal( k )
    face = M.faces(k,:);
    A = M.vertices(face(1),:);
    B = M.vertices(face(2),:);
    C = M.vertices(face(3),:);
	v1 = B-A;
	v2 = C-A;
	N = cross3( v1, v2 );
	N = N / norm( N );
    
    % if normal faces away from camera, flip it
    if dot3( N, [0,0,1] ) < 0
        N = -N;
    end
end

end