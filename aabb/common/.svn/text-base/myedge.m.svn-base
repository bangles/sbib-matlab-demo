% $Revision: 1.0$  Created on: 2008/06/18
function h = myedge( A, B, varargin )
    if size(A,2)==2
        h = myedge2(A,B,varargin{:});
    elseif size(A,2)==3
        h = myedge3(A,B,varargin{:});
    else
        error('method not available');
    end     
end %end of myline
