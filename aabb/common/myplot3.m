function h = myplot3( p, varargin )
    h = plot3( p(:,1), p(:,2), p(:,3), varargin{:} );