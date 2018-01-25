classdef Box3 < handle
   properties (SetAccess = public)
      pMin = [+inf,+inf,+inf];
      pMax = [-inf,-inf,-inf];
   end

   methods
        % constructor
        function this = Box3( varargin )
            if nargin == 1
                this.addall( varargin{1} );
            elseif nargin == 2 
                this.pMin = varargin{1};
                this.pMax = varargin{2};
            end
        end
        % copy constructor
        function new_this = copy(this)
            new_this = Box3();
            new_this.pMin = this.pMin;
            new_this.pMax = this.pMax;         
        end

        % adds a point to the bbox
        function add( this, p )
            this.pMin = min( p, this.pMin );
            this.pMax = max( p, this.pMax );
        end
        function addall( this, p )
            assert(size(p,2)==3);
            assert(size(p,2)>1);
            this.pMin = min( min(p,[],1), this.pMin );
            this.pMax = max( max(p,[],1), this.pMax );
        end

        % utilities
        function offset( this, delta )
            assert( numel(delta)==1 );
            this.pMin = this.pMin - delta;
            this.pMax = this.pMax + delta;
        end

        function p = vertices( this )
            p = zeros(8,3);
            x = xdim(this); y = ydim(this); z = zdim(this);
            p(1,:) = this.pMin + [0 0 0];
            p(2,:) = this.pMin + [x 0 0];
            p(3,:) = this.pMin + [0 y 0];
            p(4,:) = this.pMin + [x y 0];
            p(5,:) = this.pMin + [0 0 z];
            p(6,:) = this.pMin + [x 0 z];
            p(7,:) = this.pMin + [0 y z];
            p(8,:) = this.pMin + [x y z];
        end
      
        %--- Ray-box intersection
        % returns closest point of intersection between ray and box.
        % only intersections on t>0 are allowed. 
        % t<0 intersections will return NULL
        function [mint, minp] = ray_intersect( this, ray_o, ray_d )
            %--- SEE: "segment_plane_intersection.m"
            % note: denominator == 0 if they are parallel
            [p, n] = this.get_planes();
            mint = inf;
            minp = [nan,nan,nan];
            for i=1:size(p,1)
                DEN = dot3(ray_d,n(i,:)); 
                %--- Parallel ray
                if abs(DEN)<1e-10, continue; end;
                
                %--- Compute ray parameters
                t = ( dot3(p(i,:),n(i,:)) - dot3(ray_o,n(i,:)) ) / DEN;
                % disp(sprintf('%d %.2f', i, t));
                                
                %--- Compute intersection
                if( t<0 ), continue, end;
                
                %--- Test intersection point
                inters = ray_o + ray_d*t;
                if ~this.inbounds(inters), continue, end;
                    
                % Take one closest in distance
                if( t<mint )
                    mint = t;
                    minp = inters;
                end
            end
            if isinf(mint)
                mint = nan;
            end
        end


        %--- the planes composing the bounding box
        %    parametrized by point and normal
        function [p,n] = get_planes( this )
            p = zeros(6,3);
            n = zeros(6,3);
            c = this.center();
            n(1,:) = [+1  0  0];
            n(2,:) = [-1  0  0];
            n(3,:) = [ 0 +1  0];
            n(4,:) = [ 0 -1  0];
            n(5,:) = [ 0  0 +1];
            n(6,:) = [ 0  0 -1];
            p(1,:) = c+[this.xdim()/2,0,0];
            p(2,:) = c-[this.xdim()/2,0,0];     
            p(3,:) = c+[0,this.ydim()/2,0];
            p(4,:) = c-[0,this.ydim()/2,0];     
            p(5,:) = c+[0,0,this.zdim()/2];
            p(6,:) = c-[0,0,this.zdim()/2];
        end
        
        %--- Offsets the bounding box by a percentage of diagonal
        % perc .1=10%, .2=20%, ...
        function offset_perc_diag( this, perc )
            assert( numel(perc)==1 );
            assert( perc >= 0 );
            delta = perc*this.diag();
            this.offset( delta );         
        end
        
        %--- Check if set of samples is in bounds or not
        function retval = inbounds( this, p )
            EPSILON_0_SPATIAL = 1e-10; %TODO: make global variable
            E = EPSILON_0_SPATIAL;
            boundmin = ( p(:,1)>=(this.pMin(1)-E) & p(:,2)>=(this.pMin(2)-E) & p(:,3)>=(this.pMin(3)-E) );
            boundmax = ( p(:,1)<=(this.pMax(1)+E) & p(:,2)<=(this.pMax(2)+E) & p(:,3)<=(this.pMax(3)+E) );
            retval = boundmin & boundmax;
        end
        
        function c = center( this )
            c = (this.pMin + this.pMax) / 2;
        end      
        function d = diag( this )
            d = sqrt( xdim(this)^2 + ydim(this)^2 + zdim(this)^2 );
        end
        function dim = dim( this, i )
            dim = this.pMax(i) - this.pMin(i);
        end
        function xdim = xdim( this )
            xdim = this.pMax(1) - this.pMin(1);
        end
        function ydim = ydim( this )
            ydim = this.pMax(2) - this.pMin(2);
        end
        function zdim = zdim( this )
            zdim = this.pMax(3) - this.pMin(3);
        end
        function [length, dim] = max_edge( this )
            diff = [xdim(this) ydim(this) zdim(this)];
            [length, dim] = max(diff);
        end
        function [length, dim] = min_edge( this )
            diff = [xdim(this) ydim(this) zdim(this)];
            [length, dim] = min(diff);
            % this would always return 1 if equal
            % [length, dim] = min( [xdim(this), ydim(this) ] );
        end
      
   end
   
   % DEMOS
   methods(Static)
      get_planes_demo()
      ray_intersect_demo()
   end   
end
