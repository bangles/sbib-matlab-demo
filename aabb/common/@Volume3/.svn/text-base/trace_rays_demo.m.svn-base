clc, clear, close all; 
% clear all;
Volume3.trace_rays_compile();

DEMO_ID = 4;
switch DEMO_ID
   case 1 % Different angles on 2D slice
      for ang = 0.9:0.2:(pi/2)
         clf;
         
         %--- Create ray for current angle
         o = [.3 .3 0];
         d = [cos(ang) sin(ang) 0];
         
         %--- Init volume (odd causes data alignment)
         bbox = Box3( [0,0,0], [1,.5,0] );
         vol = Volume3( 11, bbox, 'f');

         %--- Trace
         vol.trace_rays(o, d, 0, 'f');
         % -2*vol.delta
         
         %--- Visualize
         movegui('east');
         vol.plot('f', 1); 
         axis('manual');
         vol.plot_ray(Ray3(o,d)); 
         mypoint2(vol.pos2offd(o),'*r');                    

         break;
         disp('type: "return" to see next iteration');
         keyboard;
      end
   
   case 2 % 2D slice
      warning('should be refactored');
      % Init volume
      bbox = Box3( [0,0,0], [1,1,1] );
      vol = Volume3( 16, bbox, 2, {'f'; 'g'} );

      % Plot empty volume
      figure;
      vol.plot('f')
      vol.plot_bbox()
      vol.plot_bbox(bbox);
      
      %-- Tests the slow tracing
      rays = Ray3.rand2(10); % 2D rays
      mtd = 0; % Slow (0) or fast (1) ray tracing
      vol.trace_rays(rays, 0, 'f', 'g', mtd)
      
      % Plot output
      figure;
      vol.plot('f', 3); % Plot selected slice #3
      %figure;
      %vol.plot('g', 3)

      %-- Compare to fast tracing
      % Init volume
      vol = Volume3( 16, bbox, 2, {'f'; 'g'} );

      % Plot empty volume
      figure;
      vol.plot('f')
      vol.plot_bbox()
      vol.plot_bbox(bbox);

      % Fast tracing
      mtd = 1; % Slow (0) or fast (1) ray tracing
      vol.trace_rays(rays, -2*delta, 'f', 'g', mtd)

      % Plot output
      figure;
      vol.plot('f', 3); 
      %figure;
      %vol.plot('g', 3)
      break
   
   case 3 % In 3D
      warning('should be refactored');
      % Init volume
      bbox = Box3( [0,0,0], [1,1,1] );
      vol = Volume3( 16, bbox, 2, {'f'; 'w'} );

      %-- Tests the tracing
      rays = Ray3.rand2(10); % 3D rays
      vol.trace_rays(rays, 0, 'f', 'w')
      
      % Plot output
      figure;
      % Plot all the slices
      %for z = 1:20
      %   figure;
      %   vol.plot('f', z);
      %end
      %patch(isosurface(vol.grids.f, 0.5)); % Plot volume
      break
    
    % 3D, using test rays from Box3.ray_intersect_demo
    % Enable "#define SIMPLYMARK" in trace.mex
    case 4    
        %--- Create ray data
        P.v = uniform_sample_sphere( 100 ); 
        P.v(1,:) = [1,0,0];
        P.d = -P.v;
        P.n = zeros( size(P.d) );
        % P.v(2:end,:) = []; P.d(2:end,:) = []; P.n(2:end,:) = [];
        
        %--- Create volume
        bbox = Box3([-1 -1 -1], [1 1 1]);
        vol = Volume3(65, bbox, 'fview');
        hold on;
        
        %--- Show original cloud
        for i=1:size(P.v,1)
            vol.plot_ray(P.v(i,:), P.d(i,:),.5);
        end
        vol.plot_samples(P.v,'.b');
                
        %--- Trace rays using BBOX
        for i=1:size(P.v,1)
            t = bbox.ray_intersect( P.v(i,:), P.d(i,:) );
            P.v(i,:) = P.v(i,:) + t*P.d(i,:);
            vol.plot_ray(P.v(i,:), P.d(i,:),.5);
        end
        vol.plot_samples(P.v,'.r');

        %--- Trace rays in discrete volume        
        % P.v = [ 1 0 0]; P.d = [-1 0 0]; P.n = [ 0 0 0];
        vol.trace_rays(P,0,0,'fview');
        vol.plot_isosurface('fview');
        break;  
      
    % 3D
    % Enable "#define SIMPLYMARK" in trace.mex
    case 5 
        % P.v = [ 1 0 0]; P.d = [-1 0 0]; P.n = [ 0 0 0];
        P.v = [ 1 1 1]; P.d = [-1 -.5 -.2]; P.n = [ 0 0 0];
        bbox = Box3([-1 -1 -1],[+1 +1 +1]);
        vol = Volume3(33, bbox, 'fview');
        vol.trace_rays(P,0,0,'fview');
        % vol.plot('fview');
        patch(isosurface(vol.grids.fview, 0.5)); 
        break;
end