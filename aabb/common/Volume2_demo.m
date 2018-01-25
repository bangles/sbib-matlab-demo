clc, clear, close all; % clear classes

DEMO_ID = 2;
switch DEMO_ID
   case 1
      bbox = Box2( [0,0], [1,1] );
      vol = Volume2( 16, bbox, 2, {'f','g'} );
      vol.init_checkerboard('f');
  
      %-- Tests the indexing
      p0 = 5*ones(100,2)*vol.delta;
      sigma = 1*vol.delta;
      p = p0 + (rand(100,2)-.5)*sigma;
  
      %-- Display
      vol.plot('f')
      vol.plot_bbox()
      vol.plot_bbox(bbox)
      mypoint2( vol.pos2off(p), 'og', 'markersize',10 )
      mypoint2( vol.pos2offd(p), '.r' )
      break
      
   case 2
      bbox = Box2( [0,0], [1,1] );
      vol = Volume2( 32, bbox, 2, {'f'; 'g'} );

      myfigure('bboxes');
      subplot(211);
      vol.plot('f')
      vol.plot_bbox()
      vol.plot_bbox(bbox);
      
      %-- Tests the tracing
      rand('seed',1);
      rays = Ray2.rand(10);
      for i=1:length(rays)
         vol.trace_ray_slow( rays{i}, 0, 'f','g' );
      end
      
      subplot(212);
      vol.plot('f'); xlim('manual');
      for i=1:length(rays), vol.plot_ray(rays{i}); end
      
      break

   case 3
      bbox = Box2( [0,0], [1,1] );
      vol = Volume2( 16, bbox, 2, {'f'; 'g'} );

      vol.plot('f')
      vol.plot_bbox()
      vol.plot_bbox(bbox);
      
      %-- Tests the tracing
      rays = Ray2.rand(10);
      mtd = 0;
      vol.trace_rays(rays, 0, 'f', 'g', mtd)
      
      myfigure('fieldonly');
      vol.plot('f')
      break
end




