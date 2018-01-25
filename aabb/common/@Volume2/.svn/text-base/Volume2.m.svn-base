% The volumes are plotted on an "orthodox" cartesian grid.
% To achieve this: 1) transpose 2) ydir: reverse
% This means: 0 bottom-left, +y is up, +x is right
% integer offsets are found at the center of pixels
% consequently, the grids are at .5
classdef Volume2 < handle
   properties (SetAccess = public)
      % bounding box
      bbox = Box2([0,0],[0,0]);
      % a set of grids of the same size
      grids = struct();
      % width/height of a cell
      delta = 0;
      % sizes of the grids
      size  = [0,0];
      % padding
      padding = 0;
   end

   methods    
      %--------------------------------------------------------------------%
      %
      %                           constructor
      %
      %--------------------------------------------------------------------%
      % padding is an integer number of deltas away
      function this = Volume2( size, bbox, padding, fieldnames )
         if nargin == 4 
            ledge = bbox.max_edge();
            this.delta = ledge / (size - 1);
            this.bbox = bbox.offset( padding*this.delta );
            this.size(2) = round( this.bbox.xdim / this.delta + 1 );
            this.size(1) = round( this.bbox.ydim / this.delta + 1 );            
            % Initialize memory 
            if iscellstr( fieldnames ) 
               for j=1:length(fieldnames)
                  % tricky, this uses "dynamic field names"
                  this.grids.(fieldnames{j}) = zeros( this.size );
               end
            elseif ischar( fieldnames )
                  this.grids.(fieldnames) = zeros( this.size );
            end
         end
      end

      %--------------------------------------------------------------------%
      %
      %                            indexing 
      %
      %--------------------------------------------------------------------%
      function off = pos2off(this, pos)
         off = zeros( size(pos,1),2 ); %#ok<CPROP,PROP>
         off(:,1) = round( ( pos(:,1)-this.bbox.pMin(1) ) / this.delta ) + 1;
         off(:,2) = round( ( pos(:,2)-this.bbox.pMin(2) ) / this.delta ) + 1;
         % assign NAN to indexes falling outside the grid range
         nilx = (off(:,1) <= 0) | (off(:,1) > this.size(1) );
         nily = (off(:,2) <= 0) | (off(:,2) > this.size(2) );
         nil_ = or( nilx, nily );
         off(nil_,1) = nan;
         off(nil_,2) = nan;
      end
      function pos = off2pos(this, off)
         pos(:,1) = (off(:,1)-1)*this.delta + this.bbox.pMin(1);
         pos(:,2) = (off(:,2)-1)*this.delta + this.bbox.pMin(2);
      end
      function off = pos2offd(this, pos)
         off = zeros( size(pos,1),2 ); %#ok<CPROP,PROP>
         off(:,1) = ( ( pos(:,1)-this.bbox.pMin(1) ) / this.delta ) + 1;
         off(:,2) = ( ( pos(:,2)-this.bbox.pMin(2) ) / this.delta ) + 1;
      end
      
      %--------------------------------------------------------------------%
      %
      %                           ray casting
      %
      %--------------------------------------------------------------------%
      function trace_rays(this, rays, startat, field1, field2, mtd)
         % Select ray tracing method
         % 0 = slow (default)
         % 1 = fast
         if ~exist('mtd', 'var')
             mtd = 0;
         end

         %%%% Old code for reference
         if 0
            if ~isdef('startat')
               startat = -this.delta;
            end
            dmax = 10e5;
            this.grids.d = ones(this.size)*dmax;
            this.grids.w = zeros(this.size);
            % trace rays
            for j=1:length(rays)
               this.trace_ray_slow( rays{j}, startat, 'w', 'd' );
            end
            return;
         end
         %%%% Old code for reference

         % Slow ray tracing
         if mtd == 0
            for i = 1:length(rays)
               this.trace_ray_slow(rays{i}, startat, 'f', 'g');
            end
         else
            % Fast ray tracing
            bb = [this.bbox.pMin this.bbox.pMax];
            Volume2_trace_rays_MEX(bb, getfield(this.grids, field1), getfield(this.grids, field2), this.delta, rays);
         end
      end
      function trace_ray_slow(this, ray, startat, field1, field2)
         curr_p = ray.p(startat);
         curr_i = this.pos2off(curr_p);
         microdelta = this.delta / 10;
         while ~isnan( curr_i(1) )
            % in first we save weight field            
            this.grids.(field1)(curr_i(1),curr_i(2)) = 1;
            
            % in second we save signed distance field (clamp'd)
            pixpos = this.off2pos( curr_i );
            % offset real distance by the "startat" amount. This
            % is because we do not want to get closer than "startat"
            t = dot( pixpos-ray.o, ray.d ) + startat;
            
            % lower the upper bound deterministically
            % here would be better to use a soft-min
            if t < this.grids.(field2)(curr_i(1),curr_i(2))
                this.grids.(field2)(curr_i(1),curr_i(2)) = t;
            end
            
            % DEBUG
            mypoint2(curr_i,'.r');
            mypoint2(this.pos2offd(curr_p),'.g');
            % pause(.05);
                        
            % increment
            curr_p = curr_p + microdelta*ray.d;
            curr_i = this.pos2off(curr_p);
         end
      end
      
      %--------------------------------------------------------------------%
      %
      %                          visualization
      %
      %--------------------------------------------------------------------%
      function plot(this, fieldname)
         % tricky, this uses "dynamic field names"
         imagesc( (this.grids.(fieldname))' );
         axis equal, axis off; hold on
         set(gca,'YDir','normal')
         colormap 'gray'
      end
      function plot_bbox(this, bbox)
         if nargin == 1
            lpmin = this.pos2offd( this.bbox.pMin );
            lpmax = this.pos2offd( this.bbox.pMax );
            color = 'blue';
         else
            lpmin = this.pos2offd( bbox.pMin );
            lpmax = this.pos2offd( bbox.pMax );
            color = 'red';
         end
         
         xs = [lpmin(1), lpmax(1), lpmax(1), lpmin(1), lpmin(1)];
         ys = [lpmin(2), lpmin(2), lpmax(2), lpmax(2), lpmin(2)];
         line( xs, ys, 'color', color );
      end
      function plot_ray(this, ray)
         p1 = this.pos2offd(ray.o);
         p2 = this.pos2offd(ray.o+5*ray.d);
         myedge2(p1,p2);
      end
      

      %--------------------------------------------------------------------%
      %
      %                          initialization
      %
      %--------------------------------------------------------------------%
      % creates a checkerboard pattern on a specified grid
      function init_checkerboard(this, fieldname)
         if ~isfield( this.grids, fieldname )
            error('cannot init f with checkerboard if grid f has not been declared');
         end
         for x=1:this.size(1)
            for y=1:this.size(2)
               this.grids.(fieldname)(x,y) = xor( mod( x,2 ), mod( y,2 ) );
            end
         end
      end
      % creates an euclidean distance field with zero located at padding of image
      function phi0 = init_phi0(this)
         p = this.padding;
         s = this.size;
         phi0 = ones(s);
         phi0(p:s(1)-p, p:s(2)-p) = -1;
         phi0 = double((phi0 > 0).*(bwdist(phi0 < 0)-0.5) - (phi0 < 0).*(bwdist(phi0 > 0)-0.5));
      end
   end
end
