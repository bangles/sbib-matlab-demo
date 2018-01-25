% TODO: add documentation
function h = myline2( p, v, scale, varargin )  
    v = v.*scale;
    h = line( [p(:,1), p(:,1)+v(:,1)]', [p(:,2), p(:,2)+v(:,2)]', varargin{:} );
end
