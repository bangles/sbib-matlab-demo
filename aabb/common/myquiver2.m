function h = myquiver2( P, V, varargin )
    h = quiver( P(:,1), P(:,2), V(:,1), V(:,2), varargin{:} );
end