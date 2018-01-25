classdef Multigrid2
   properties (SetAccess = public)
      vols = {}
   end

   methods
      % CONSTRUCTOR
      % the grid is minres in the smallest of dimensions so that if that's 
      % a power of two we can apply multigrid to k levels. the number of 
      % sub levels can be specified or it's automatically computed
      function this = Multigrid2( minres, bbox, padding, fieldnames, numlevels )
         error('this needs to be revised!! Multigrid3 is the correct one!!');
         
          %--- checks dim is a power of two
         assert( rem(log2(minres),1)==0 );

         %--- check field names is string or struct of strings
         assert( ischar(fieldnames) | iscellstr(fieldnames) );
         
         %--- size of largest scale grid
         msize = zeros(1,2);
                  
         %--- compute delta for smallest edge
         [dmin, imin] = bbox.min_edge();
         delta = dmin / (minres-1);
         msize( imin ) = minres;
         
         %--- expand box on bigger axes so that their dim is a power of two
         [dmax, imax] = bbox.max_edge();
         original_dim = round( dmax / delta + 1 );
         new_dim = 2^ceil( log2(original_dim) );
         msize( imax ) = new_dim;
         
         
         %--- allocate memory
         if ~exist('numlevels','var')
            numlevels = log2(minres)-3;
         else
            numlevels = numlevels;
         end
         curr_size  = [msize(2), msize(1)];
         curr_delta = delta;
         curr_box   = Box2();
         this.vols = cell( numlevels, 1 );
         box_center  = bbox.center();
         
         for i=1:numlevels
            grid_center = fliplr( (curr_size+2*padding)/2-.5 );
            curr_box.pMax = box_center + grid_center*curr_delta;
            curr_box.pMin = box_center - grid_center*curr_delta;
            
            % Initialize the i-th level of multigrid
            this.vols{i} = Volume2();
            this.vols{i}.delta = curr_delta;
            this.vols{i}.bbox  = curr_box;
            this.vols{i}.size = curr_size+2*padding;
            this.vols{i}.padding = padding;
            
            % Initialize memory 
            if iscellstr( fieldnames ) 
               for j=1:length(fieldnames)
                  % tricky, this uses "dynamic field names"
                  this.vols{i}.grids.(fieldnames{j}) = zeros( this.vols{i}.size );
               end
            elseif ischar( fieldnames )
                  this.vols{i}.grids.(fieldnames) = zeros( this.vols{i}.size );
            end
               
               
            % next level has smaller resolution
            % and consequently bigger delta
            curr_delta = curr_delta * 2;
            curr_size  = curr_size  / 2;
         end
      end
      
      function nl = numlevels(this)
         nl = length(this.vols);
      end
      
      function display(this)
         title = sprintf('%10s %10s %10s %15s %15s', 'level', 'size', 'delta', 'bbox.pMin', 'bbox.pMax');
         disp( title );
         title(:) = '-';
         disp( title );
         for i=1:length(this.vols)
            delta = this.vols{i}.delta;
            dims = sprintf('%d %d', this.vols{i}.size );
            bounds1 = sprintf('[%.2f %.2f]', this.vols{i}.bbox.pMin );
            bounds2 = sprintf('[%.2f %.2f]', this.vols{i}.bbox.pMax );
            fprintf(1,'%10d %10s %10.3f %15s %15s\n', i, dims, delta, bounds1, bounds2);
         end
      end
   end
end