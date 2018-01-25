classdef Volume3 < dynamicprops
    %#ok<*CPROP,*PROP>
    properties (SetAccess = public)
        % bounding box
        bbox = Box3([0,0,0],[0,0,0]);
        % a set of grids of the same size
        grids = struct();
        % width/height of a cell
        delta = 0;
        % sizes of the grids
        size  = [0,0,0];
        % initialized?
        isInit = false;
    end

    methods    
        %--------------------------------------------------------------------%
        %
        %                           constructors
        %
        % Examples:
        % Volume3( );
        % Volume3( size, bbox );
        % Volume3( size, bbox, 'fn1' );
        % Volume3( size, bbox, {'fn1','fn2'} );
        %--------------------------------------------------------------------%
        function this = Volume3( size, bbox, fieldnames )
            if nargin >=2
                this.bbox = bbox;
                ledge = bbox.max_edge();
                this.delta = ledge / (size - 1);
                this.size(3) = round( this.bbox.zdim / this.delta + 1 );
                this.size(2) = round( this.bbox.ydim / this.delta + 1 );
                this.size(1) = round( this.bbox.xdim / this.delta + 1 );
            end
            if nargin >= 3
                % Initialize memory 
                if iscellstr( fieldnames ) 
                   for j=1:length(fieldnames)
                      % tricky, this uses "dynamic field names"
                      this.grids.(fieldnames{j}) = zeros( this.size(1), this.size(2), this.size(3) );
                   end
                elseif ischar( fieldnames )
                      this.grids.(fieldnames) = zeros( this.size(1), this.size(2), this.size(3) );
                end
            end
        end

      %--------------------------------------------------------------------%
      %
      %                            indexing 
      %
      %--------------------------------------------------------------------%
      function off = pos2off(this, pos)
         off = zeros( size(pos,1),3 );
         off(:,1) = round( ( pos(:,1)-this.bbox.pMin(1) ) / this.delta ) + 1;
         off(:,2) = round( ( pos(:,2)-this.bbox.pMin(2) ) / this.delta ) + 1;
         off(:,3) = round( ( pos(:,3)-this.bbox.pMin(3) ) / this.delta ) + 1;
         
         % assign NAN to indexes falling outside the grid range
         nilx = (off(:,1) <= 0) | (off(:,1) > this.size(1) );
         nily = (off(:,2) <= 0) | (off(:,2) > this.size(2) );
         nilz = (off(:,3) <= 0) | (off(:,3) > this.size(3) );
         nil_ = or( or( nilx, nily ), nilz);
         off(nil_,1) = nan;
         off(nil_,2) = nan;
         off(nil_,3) = nan;
      end
      function off = pos2offd(this, pos)
         off = zeros( size(pos,1),3 );
         off(:,1) = ( ( pos(:,1)-this.bbox.pMin(1) ) / this.delta ) + 1;
         off(:,2) = ( ( pos(:,2)-this.bbox.pMin(2) ) / this.delta ) + 1;
         off(:,3) = ( ( pos(:,3)-this.bbox.pMin(3) ) / this.delta ) + 1;
      end
      function ind = pos2ind(this,pos)
         off = this.pos2off(pos);
         ind = sub2ind(this.size,off(:,1),off(:,2),off(:,3));
      end
      function pos = ind2pos(this,ind)
         [o1,o2,o3] = ind2sub(this.size,ind);
         pos = this.off2pos( [o1,o2,o3] );
      end
      function pos = off2pos(this, off)
         pos = zeros( size(off,1),3 );
         pos(:,1) = (off(:,1)-1)*this.delta + this.bbox.pMin(1);
         pos(:,2) = (off(:,2)-1)*this.delta + this.bbox.pMin(2);
         pos(:,3) = (off(:,3)-1)*this.delta + this.bbox.pMin(3);
      end
      
      %--------------------------------------------------------------------%
      %                      Distance field creation
      % 1: we have data
      % 0: we don't have data
      %--------------------------------------------------------------------%
      function data_field(this,P,slack,dmax,field)
         % Initialize a 1/0 matrix at sample locations
         o = P.vertices +slack*P.viewdirs;
         assert( all(P.bbox.inbounds(o)), 'offsetted viewdirs go out of bounds' );
         
         % Backdrop rays are not data...
         idel = ( sum( (P.vnormals).^2, 2 ) < 1e-5 );
         o(idel,:) = [];
         
         % Convert vertices in volume coordinates
         off = this.pos2offd(o);

         % Create splattin kernel
         % if kernel order is even.. odd'it
         std = dmax/4;
         N = ceil(std*4);
         if mod(N,2)==0, N = N+1; end
         K = mygaussian3(N,std);
         
         % Perform the splatting
         this.grids.(field) = splat_vertices3(off,this.grids.(field),K);
         
         % Normalize the splatting 0..1
         fieldmax = max(max(max(this.grids.(field))));
         this.grids.(field) = (this.grids.(field))/fieldmax;
      end
      
      %--------------------------------------------------------------------%
      %                         Volumetric force
      %--------------------------------------------------------------------%
      function mforce( this, Lz )
          if nargin~=2, error('2 arguments'); end;
          
          disp('MFORCE:');
          %--- Extract medial
          time = tic; 
          fprintf(1,' - MEDIAL3:\n');
          [S,fvol] = medial3( this.grids.phi, this.grids.dfield );
          fprintf(1,'   - Time: %.2f\n',toc(time));
          
          %--- Construct the implicit function of target surface
          time = tic;
          fprintf(1,' - EXTEND:\n');
          this.grids.fvol = fextend( this.grids.phi, Lz, S, -fvol );
          fprintf(1,'   - Time:  %.2f\n',toc(time));
      end
      
      %--------------------------------------------------------------------%
      %                           Ray casting
      %--------------------------------------------------------------------%
      function trace_rays(this, rays, startat, slack, field)
         assert( size(rays.vertices,2)==3 );
         assert( size(rays.viewdirs,2)==3 );
         assert( size(rays.vertices,1)>0  );
         assert( size(rays.viewdirs,1)>0  );
         assert( all(size(rays.viewdirs)==size(rays.vertices)) );
         t = double( sum( (rays.vnormals).^2, 2 ) > 1e-5 );
         assert( all( this.bbox.inbounds(rays.vertices) ) );
         this.trace_rays_MEX(rays.vertices, rays.viewdirs, t, startat, slack, this.grids.(field), this.delta, this.bbox.pMin, this.bbox.pMax);
      end

      %--------------------------------------------------------------------%
      %                       Level Set Wrappers
      %--------------------------------------------------------------------%
      function [Lz,ITERS,DEB] = ls_evolve(this,niters,lambda1,lambda2)
         if niters>0, fprintf(1,' - EVOLVE:\n'); time=tic; end;
         [Lz,ITERS,DEB] = levelset_evolve(this.grids.phi, this.grids.labels, ...
                                          this.grids.fview, this.grids.fvol, ...
                                          this.grids.dfield, ...
                                          niters,lambda1,lambda2,false);
         if niters>0, fprintf(1,'   - Time:  %.2f\n',toc(time)); end;
      end
      function ls_init(this,p)
         % creates 0/1 phi and converts to LS implicit function
         s = this.size;
         this.grids.phi(1+p:s(1)-p, 1+p:s(2)-p, 1+p:s(3)-p) = 1;
         levelset_evolve(this.grids.phi, this.grids.labels, ...
                         this.grids.fview, this.grids.fvol, ...
                         this.grids.dfield, ...
                         0,0,0,true);
         this.isInit = true;
      end
      
      %--------------------------------------------------------------------%
      %                          Visualization
      %--------------------------------------------------------------------%
      function plot(this, fieldname, z)
         if ~exist('z', 'var'), z = round(this.size(3)/2); end
         % SEE "dynamic field names"
         slice = (this.grids.(fieldname)(:, :, z))';
         % slice = squeeze(this.grids.(fieldname)(z,:,:))'; %REMOVEME
         imagesc( slice );
         axis equal, axis off; hold on;
         set(gca,'YDir','normal');
         colormap('jet');
         hold on;
      end
      function plot_contour(this, fieldname, z, varargin)
         if nargin<3 || isempty(z), z = round(this.size(3)/2); end
         slice = this.grids.(fieldname)(:,:,z);
         if numel(varargin)==0, varargin={'-b'}; end;
         contour(slice',[0,0],varargin{:});             
      end
      function save_isosurface(this, fieldname, filename)
         mesh = implicit_surface_mesher(this.grids.(fieldname));
         mesh_write_obj(mesh, filename);
      end
      function p = plot_isosurface(this, fieldname, cfieldname, filename)
         clf;
         
         % isosurface expects matlab classic indexing
         temp = permute(this.grids.(fieldname),[2 1 3]);
         mesh = isosurface(temp,0);

         % take vertices and find out where they lie
         if nargin>=3 && ~isempty(cfieldname)
            vi = round( mesh.vertices );
            I = sub2ind(this.size, vi(:,1),vi(:,2),vi(:,3) );
            mesh.FaceVertexCData = this.grids.(cfieldname)(I); 
         end
         
         p = patch(mesh); camlight;
         axis equal;
         xlim( [0 this.size(1)]); xlabel('x');
         ylim( [0 this.size(2)]); ylabel('y');
         zlim( [0 this.size(3)]); zlabel('z');
         set(p, 'FaceLighting', 'phong');

         set(p,'EdgeColor','none');

         if nargin==2 || isempty(cfieldname)
            set(p,'FaceColor','red');
         elseif nargin>=3 && ~isempty(cfieldname)
            shading interp
         end
         
         % finally save to file
         if nargin==4
            mesh_write_obj(mesh, filename);
         end
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
        function plot_samples(this, v, opts)
            if nargin == 2, opts='.b'; end;
            %--- Convert samples to continuous
            %    grid space for plotting
            v = this.pos2offd( v );
            hold on; 
            myplot3(v,opts);
        end
        function plot_ray(this, ray_o, ray_d,length)
            p1 = this.pos2offd(ray_o);
            p2 = this.pos2offd(ray_o+length*ray_d);
            myedge3(p1,p2);
        end

      %--------------------------------------------------------------------%
      %
      %                          initialization
      %
      %--------------------------------------------------------------------%
      % creates an euclidean distance field with zero located at some X voxels away from boundary
      function phi0 = init_phi0(this, offset)
         p = offset;
         s = this.size;
         phi0 = ones(s);
         phi0(p:s(1)-p, p:s(2)-p) = -1;
         phi0 = double((phi0 > 0).*(bwdist(phi0 < 0)-0.5) - (phi0 < 0).*(bwdist(phi0 > 0)-0.5));
      end
   end
   
   methods(Static)
      trace_rays_compile()
      trace_rays_demo()
   end   
end
