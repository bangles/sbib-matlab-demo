function h = myscatter3( P, varargin )
    h = scatter3( P(:,1), P(:,2), P(:,3), varargin{:} );
end