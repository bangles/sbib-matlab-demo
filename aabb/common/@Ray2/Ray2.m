classdef Ray2
   properties (SetAccess = public)
      o = [0,0];
      d = [0,0];
      tmax = 0;
   end
   
   methods
      % constructor
      function this = Ray2( o, d, tmax )
         if nargin == 3
            this.o = o;
            this.d = d;
            this.tmax = tmax;
         else
            disp('Missing arguments to initialize Ray');
         end
      end
      
      function pt = p( this, t )
         pt = this.o + t*this.d;
      end
      
      function pt = pmax( this )
         pt = this.o + this.tmax*this.d;
      end
   end
   
   methods(Static)
      % generates random rays with position [0,1]
      % and directions [-1,1],[-1,1]
      function rays = rand( m )
         rays = cell(m,1);
         ps = rand(m,2);
         ns = rand(m,2)-.5;
         ns_norms = sqrt( sum(ns.^2, 2) );
         ns(:,1) = ns(:,1)./ns_norms;
         ns(:,2) = ns(:,2)./ns_norms;
         for i=1:m
            rays{i} = Ray2(ps(i,:),ns(i,:),0);
         end
      end
   end
end
