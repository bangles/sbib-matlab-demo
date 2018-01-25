% MEDIAL2 computes medial axis of a solid object represented by an implicit function
%
% [M,C] = medial( phi, TH_ALPHA, EPSILON )
%
% INPUT PARAMETERS
%   phi: implicit function represented by a MxN matrix: 
%       - phi(i,j)= -1    inside object
%       - phi(i,j)= +1    outside object
%       - phi(i,j)=  0    oubject boundary
%   TH_ALPHA: the angle (radians) filter to discard unimportant medial samples 
%
% OUTPUT PARAMETERS
%   M: a graph structure with several fields:
%       - vertices: Nx2 matrix of medial vertices
%       - viv: Nx1 cell of connectivity (incident vertices of indexed medial vertice)
%       - corr: the correspondence from M to C
%       - r: Nx1 matrix of average radius of unpruned vertices
% 
%   C: a graph describing the contour of the object.
%       - vertices: Nx2 matrix of contour vertices
%       - viv: Nx1 cell of graph connectivity
%       - r: Nx1 matrix of average spoke length
%
% DESCRIPTION
% The medial axis can be thought of as a subsampling of the voronoi diagram [1]. We first compute 
% the voronoi diagram and we mark its samples as inside/outside using the implicit function. We 
% keep the connectivity of the inside samples only and measures the corresponding spoke aperture [2].
% If this aperture is unsatisfactory a node is marked to be pruned. We make sure the topology of the
% shape is maintained by pruning only edges that don't alter the topology of the shape.
% 
% Hint: Note that if you have a bw image, you can compute an implicit function by using bwdist.
% You will have to apply two bwdist transform, one on I, one on 1-I, in order to obtain a full 
% signed euclidean field of the shape. 
% 
% EXAMPLE
% description of example for medial
% >> load medial2.mat phi;
% >> M = medial2( phi, pi/2 );
% >> mygraph2(M);
% >>
% 
% References:
% [1] Tamal K. Dey and Wulue Zhao, "Approximating the Medial Axis from the 
%     Voronoi Diagram with a Convergence Guarantee," Algorithmica (38) 2004, 
%     pages 387-398.
% [2] Andrea Tagliasacchi, Richard Hao Zhang, Daniel Cohen-Or, "Curve skeleton
%     extraction from incomplete point cloud," in ACM Transactions on Graphics
%     (Proceedings of SIGGRAPH), 2009.

% Library requirements:
% - kdtree: compute correspondences
% - common:
%   - symm_normal2: compute spoke aperture
%   - mygraph2: viz graph
%   - circle: debug of radii estimates
%   - myisoline2: extract phi isocontour
% - queue: progressively filter medials

% Copyright (c) 2010 Andrea Tagliasacchi
% All Rights Reserved
% email: andrea.tagliasacchi@gmail.com
% $Revision: 1.0$  Mar.10,2010 15:15:07: created
function [M,C] = medial2( phi, TH_ALPHA, EPSILON, DELTA )

%--------------------------------------------------------------------------------------------------%
%                                           DEBUG SETUP                                            %
%--------------------------------------------------------------------------------------------------%
DEBUG_INOUT = 0;
DEBUG_ERODE = 0;
DEBUG_CORRE = 0;
DEBUG_RADII = 0;
DEBUG_CLEAN = 0;
DEBUG = DEBUG_INOUT || DEBUG_ERODE || DEBUG_CORRE || DEBUG_RADII || DEBUG_CLEAN;
if DEBUG
    clc, close all;
    load data/uuu.vol.mat phi;
    warning('debug mode enabled'); %#ok<WNTAG>
    %--- Figure 1: distance field
    figure(1), hold on; imagesc(phi);
    axis image, axis off; movegui('northeast')
end
if DEBUG_INOUT
    %--- Figure 2: only contour
    figure(2), hold on; axis off; 
    xlim( [1, size(phi,1) ] );
    ylim( [1, size(phi,2) ] );
    axis square;
    movegui('east')
end
if DEBUG_ERODE
    figure(3), hold on; axis off; 
    xlim( [1, size(phi,1) ] );
    ylim( [1, size(phi,2) ] );
    axis square;
    movegui('southeast')
end
if DEBUG_RADII
    figure(4); hold on; axis off;
    xlim( [1, size(phi,1) ] );
    ylim( [1, size(phi,2) ] );
    axis square;
    movegui('southeast')
end   

%--------------------------------------------------------------------------------------------------%
%                                       DEFAULT PARAMETERS                                         %
%--------------------------------------------------------------------------------------------------%
if ~exist('TH_ALPHA','var')
    TH_ALPHA = pi/2;
end
if ~exist('EPSILON','var')
    EPSILON = 1e-3;
end
if ~exist('DELTA','var')
    DELTA = 0;
end

%--- Extract isosurface & discard too small edges
[C.vertices, C.viv] = myisoline2( phi, [0,0], DELTA );
if DEBUG, figure(1), mygraph2( C, '-r' ); end;
    
%--- Compute the voronoi diagram (CELLS: voronoi polytopes)
vor_in = unique( C.vertices, 'rows' );
[M.vertices,M.polytopes] = voronoin( vor_in );

%--- Flag vertexes as: inside (-1) outside (+1) out bounds (2)
M.type = inside_outside_flags( M.vertices, phi );
if DEBUG_INOUT, 
    figure(2), mygraph2( C, '-r' ); 
    myscatter2( M.vertices, 20, M.type, 'filled' ); 
end;

%--- Compute (interior) medial points by angle measure
M.alpha = spoke_angles( M.vertices, M.type, C.vertices );

%--- Converts voronoi connectivity (SLOW!!!)
M.viv = graph_poly_to_viv( M.polytopes, M.type==-1 );
if DEBUG_ERODE, figure(3), mygraph2(C,'-r'); mygraph2( M, '-b' ); end

%--- Compute distance medial to boundary and correspondences
[M.dst, M.corr] = mat_surf_relations( M, C, EPSILON );
if DEBUG_CORRE
    figure(3);
    for vIdx=1:size(M.vertices,1)
        for nIdx=1:size(M.corr{vIdx})
            myedge2( M.vertices(vIdx,:), C.vertices(M.corr{vIdx}(nIdx),:), 'color', 'red' );
        end
    end
end

%--- Erode skeleton outside-in 
M = erode_skeleton( M, TH_ALPHA );
if DEBUG_ERODE, mygraph2( M, '-r' ); end

%--- Compute the average radii
M.r = mat_avg_radii( M, C );
if DEBUG_RADII
    % visual medial reconstruction
    figure(4); hold on
    for i=find( M.type==-1 )'
        circle( M.vertices(i,:), M.r(i,:) );
    end
end

%--- Remove M.type==-1, not useful fields and update all references
M = rmfield( M, 'polytopes' );
M = rmfield( M, 'alpha' );
M = rmfield( M, 'dst' );

M.vertices = M.vertices( M.type==-1,: );
M.corr = M.corr( M.type==-1 );
% update all references with new indexes
M.viv = M.viv( M.type==-1 );
M.r   = M.r( M.type==-1 );
v_newidx = cumsum( M.type==-1 );
v_newidx( M.type~=-1 ) = nan; %security
for vIdx=1:size(M.viv)
    M.viv{vIdx} = v_newidx( M.viv{vIdx} );
end
M = rmfield( M, 'type' );
if DEBUG_CLEAN
    % SHOW EVERYTHING
    mygraph2( M, '.r' );
    for vIdx=1:size(M.vertices,1)
        circle( M.vertices(vIdx,:), M.r(vIdx,:) );
        for nIdx=1:size(M.corr{vIdx})
            myedge2( M.vertices(vIdx,:), C.vertices(M.corr{vIdx}(nIdx),:), 'color', 'yellow' );
        end
    end    
end

%--- Compute average contour spoke length
C.r = zeros( size(C.vertices,1), 1 );
cnt = zeros( size(C.vertices,1), 1 );
for mIdx=1:size(M.vertices)
    c_idxs = M.corr{mIdx};
    for cIdx=c_idxs(:)'
        C.r( cIdx ) = C.r( cIdx ) + norm( C.vertices(cIdx,:)-M.vertices(mIdx,:) );
        cnt( cIdx ) = cnt( cIdx ) + 1;
    end
end
C.r = C.r ./ cnt;

%--------------------------------------------------------------------------------------------------%
%                                                                                                  %
%                                           UTILITIES                                              %
%                                                                                                  %
%--------------------------------------------------------------------------------------------------%
%--- Compute "average" radius of medial samples. 
% We need an average since we filtered away some medial samples, thus some surface samples end up 
% with no corresponding medial support
function R = mat_avg_radii( M, C )
    R = nan( size(M.vertices,1), 1 );
    for vIdx = find( M.type==-1 )'
        R(vIdx) = 0;
        for j=1:length( M.corr{vIdx} )
            R(vIdx) = R(vIdx) + norm( M.vertices(vIdx,:)-C.vertices(M.corr{vIdx}(j),:) );
        end
        R(vIdx) = R(vIdx) / length(M.corr{vIdx});
    end

%--- Erode skeleton outside-in 
% Erode small spoke-aperture vertices starting from close to surface
% eroding toward medial, so that topology of the original surface is 
% maintained. Remember that M.dst is always positive.
function M = erode_skeleton( M, TH_ALPHA )
    del_flags = M.alpha < TH_ALPHA*90/180;
    act_verts_idxs = find( M.type==-1 & del_flags )';
    act_verts_dsts = M.dst( M.type==-1 & del_flags );
    [IGN, sortI] = sort( act_verts_dsts, 'ascend' );
    act_verts_idxs = act_verts_idxs( sortI );
    for vIdx=act_verts_idxs
        % if it has only one neighbor (not breaks loop)
        if numel( M.viv{vIdx} ) == 1
            M.type(vIdx)=-2;  % disable sample
            nn = M.viv{vIdx}; % only-neighbor
                        
            % delete connections on both sides
            M.viv{nn}( M.viv{nn} == vIdx ) = []; 
            M.viv{vIdx}=[];

            % propagate correspondences
            M.corr{nn} = union( M.corr{nn}, M.corr{vIdx} );
            M.corr{vIdx} = [];            
        end
    end
    


%--- Distance from medial vertices to the surface
function [dst, corr] = mat_surf_relations( M, C, EPSILON )
    dst = nan( size(M.vertices,1), 1 );
    corr = cell(size(M.vertices,1),1);
    kdtree = kdtree_build( C.vertices );
    % compute distance from surface & corresp for inside MAT
    for vIdx=1:size(M.vertices,1)
        if M.type(vIdx) ~= -1, continue, end;
        [IGN, dst(vIdx)] = kdtree_nearest_neighbor( kdtree, M.vertices(vIdx,:) );

        % compute correspondences for inside mat
        corr{vIdx} = kdtree_ball_query( kdtree, M.vertices(vIdx,:), dst(vIdx)+EPSILON );   
    end
    kdtree_delete( kdtree );

%--- Mark voronoi vertices as "inside" or "outside"
function type = inside_outside_flags( v, phi )
    type = zeros( size(v,1),1 );
    for vIdx=1:size(v,1)
        curr = round( v(vIdx,:) );
        % outside the bounding box
        if curr(1) > size(phi,1) || ...
           curr(2) > size(phi,2) || ...
           curr(1) <= 0 || ...
           curr(2) <= 0,
           type( vIdx ) = 2;
        % use phi to decide inside/outside. Round, do not interpolate
        % Inside voronoi elements are negative, Outside positive
        else
            type( vIdx ) = sign( phi(curr(2),curr(1)) );       
        end
    end

%--- Compute the spoke aperture of a medial axis point.
function alpha = spoke_angles( v, type, c )
    alpha = zeros( size(v,1), 1 );
    % how much further than nearest neighbor I should look
    EPS = 1e-5;
    kd = kdtree_build( c ); % query accellerator 
    for vIdx=1:size(v,1)
        % only need to query interior samples
        if type( vIdx ) ~= -1, continue, end;
        %--- query delta-closest neighbors (bi-tangent)
        [ign, d] = kdtree_nearest_neighbor( kd, v(vIdx,:) );
        R(vIdx) = d;
        idxs = kdtree_ball_query( kd, v(vIdx,:), d+EPS );  
        %--- Create medial spokes and then 
        spokes = c(idxs,:) - repmat(v(vIdx,:),length(idxs),1);
        %--- Compute medial tangent
        symmn = symm_normal2(spokes);
        %--- Measure average aperture angle
        angles = acos( abs( arrayfun( @(x,y) dot( [x,y], symmn )/...
                      (norm([x,y])*norm(symmn)), spokes(:,1), spokes(:,2) ) ) );
        alpha(vIdx) = mean( angles );
    end
    kdtree_delete( kd );