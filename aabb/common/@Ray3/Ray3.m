classdef Ray3
   properties (SetAccess = public)
      o = [0,0,0];
      d = [0,0,0];
      tmax = 0;
   end
   
   methods
      % constructor
      function this = Ray3( o, d, tmax )
         if nargin >= 2
            this.o = o;
            this.d = d;
            if nargin >= 3
               this.tmax = tmax;
            else
               this.tmax = inf;
            end
         else
            disp('Missing arguments to initialize Ray3');
         end
      end
      
      function pt = p( this, t )
         pt = this.o + t*this.d;
      end
      
      function this = offset( this, t )
         this.o = this.o + t*this.d;
      end
      
      function pt = pmax( this )
         pt = this.o + this.tmax*this.d;
      end
   end
   
   methods(Static)
      % generates random 2D rays with position [0,1]
      % and directions [-1,1],[-1,1]
      function rays = rand2( m )
         rays = cell(m,1);
         ps = rand(m,3);
         ns = rand(m,3)-.5;
         ps(:, 3) = 0;
         ns(:, 3) = 0;
         ns_norms = sqrt( sum(ns.^2, 2) );
         ns(:,1) = ns(:,1)./ns_norms;
         ns(:,2) = ns(:,2)./ns_norms;
         for i=1:m
            rays{i} = Ray3(ps(i,:),ns(i,:),0);
         end
      end

      % generates random rays in 3D
      function rays = rand( m )
         rays = cell(m,1);
         ps = rand(m,3);
         ns = rand(m,3)-.5;
         ns_norms = sqrt( sum(ns.^2, 2) );
         ns(:,1) = ns(:,1)./ns_norms;
         ns(:,2) = ns(:,2)./ns_norms;
         ns(:,3) = ns(:,3)./ns_norms;
         for i=1:m
            rays{i} = Ray3(ps(i,:),ns(i,:),0);
         end
      end
   end
end
