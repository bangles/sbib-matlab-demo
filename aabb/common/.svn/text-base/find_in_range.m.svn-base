function setidxs = find_in_range( p_or_h, SET )

if ishandle( p_or_h )
    h = p_or_h;
    [xl,yl] = ginput( 1 );
    [xh,yh] = ginput( 1 );
    range = [xl, yl; xh, yh];
    range = [ min( range ); max( range ) ]';
    
    % only for 3D clouds
    if size(SET,2)==3
        range(end+1,:) = [-inf inf];
        % extract hg matrix
        hg = findobj( h,'Type','hgtransform');
        if( numel(hg)>0 )
            hg = hg(1);
            T = get( hg, 'Matrix' );
            % rotate the SET with the matrix
            P.points = SET;
            set = pcloud_affine_transform( P, T );
        else
            set = SET;
        end
    else
        set = SET;
    end
       
    
    % construct kdtree over the set
    kdtree = kdtree_build( set );
    % make orthogonal query
    setidxs = kdtree_range_query( kdtree, range );
    % free memory
    kdtree_delete( kdtree );
    
    hold on;
    if size(SET,2)==3 && ~isempty(hg)
        myplot3( SET(setidxs,:), '*g', 'parent', hg );
    elseif size(SET,2)==3
        myplot3( SET(setidxs,:), '*g' );
    else
        myplot2( SET(setidxs,:), '*g');
    end    
end