classdef Box2 < handle
   properties (SetAccess = public)
      pMin = [+inf,+inf];
      pMax = [-inf,-inf];
   end

   methods
      % constructor
      function this = Box2( p1, p2 )
         if nargin == 1
            this = Box2();
            this.addall( p1 );
         end
         
         if nargin == 2 
            this.pMin = p1;
            this.pMax = p2;
         end
      end
      % copy constructor
      function new_this = copy( this )
         new_this = Box2();
         new_this.pMin = this.pMin;
         new_this.pMax = this.pMax;         
      end
      
      % adds a point to the bbox
      function add( this, p )
         this.pMin = min( p, this.pMin );
         this.pMax = max( p, this.pMax );
      end
      function addall( this, p )
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
      
      % perc .1=10%, .2=20%, ...
      function offset_perc_diag( this, perc )
         assert( numel(perc)==1 );
         assert( perc >= 0 );
         delta = perc*this.diag();
         this.offset( delta );
      end
      % used to programmatically set bounds of axis
      function setaxisbounds( this, perc )
         t = this.copy();
         t.offset_perc_diag( perc );
         axis([t.pMin(1) t.pMax(1) t.pMin(2) t.pMax(2)]);
      end
      function c = center( this )
         c = (this.pMin + this.pMax) / 2;
      end
      function d = diag( this )
         d = sqrt( xdim(this)^2 + ydim(this)^2 );
      end
      function xdim = xdim( this )
         xdim = this.pMax(1) - this.pMin(1);
      end
      function ydim = ydim( this )
         ydim = this.pMax(2) - this.pMin(2);
      end
      % vertices of bounding box
      function p = vertices( this )
         p = zeros(4,2);
         p(1,:) = this.pMin;
         p(2,:) = this.pMax;
         p(3,:) = this.pMin + [xdim(this),0];
         p(4,:) = this.pMin + [0,ydim(this)];
      end
      function [length, dim] = max_edge( this )
         if ydim(this) >= xdim(this) 
            length = ydim(this);
            dim = 2;
         else
            length = xdim(this);
            dim = 1;
         end
      end
      function [length, dim] = min_edge( this )
         % this would always return 1 if equal
         % [length, dim] = min( [xdim(this), ydim(this) ] );
         if xdim(this) <= ydim(this)
            length = xdim(this);
            dim = 1;
         else
            length = ydim(this);
            dim = 2;
         end
      end
      
   end
end