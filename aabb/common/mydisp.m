% same as disp( sprintf(...) )
function mydisp(varargin)
   disp(sprintf(varargin{:})); %#ok<*DSPS>
