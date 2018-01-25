% nearIdx = find_closest( p_or_h, SET )
function nearIdx = find_closest( p_or_h, SET )

if ishandle( p_or_h )
    h = p_or_h;
    [x,y] = ginput( 1 );
    currp = [x,y];
    hg = findobj( h,'Type','hgtransform');
    hg = hg(1);

%   plot( x, y, '*g', 'parent', hg );
    
    M_tr = inv( get(hg,'Matrix') );
    A = M_tr*[ currp(1), currp(2), 100, 1]';
    B = M_tr*[ currp(1), currp(2), -1, 1]';
    A = A / A(4);
    B = B / B(4);

    p = A(1:3)';
    v = (B(1:3)-A(1:3))'/norm(B(1:3)-A(1:3));
    
    % check the projection distance of every point to 
    % this line
    nearDst = inf;
    nearIdx = 0;
    for pIdx=1:size(SET,1)
        d = norm( cross3( (SET(pIdx,:)-p), v ) );
        if d < nearDst
            nearDst = d;
            nearIdx = pIdx;
        end
    end
    mypoint3( SET(nearIdx,:), '*g', 'markersize', 10, 'parent', hg );
    % disp(sprintf('coordinates: %.3f %.3f %.3f', SET(nearIdx,:) ));
    
elseif numel( p_or_h ) == 3
    p = p_or_h;

    nearDst = inf;
    nearIdx = 0;
    for pIdx=1:size(SET,1)
        d = euclidean_distance( p, SET(pIdx,:) );
        if d < nearDst
            nearDst = d;
            nearIdx = pIdx;
        end
    end

elseif numel( p_or_h ) == 2
    p = p_or_h;

    nearDst = inf;
    nearIdx = 0;
    for pIdx=1:size(SET,1)
        d = norm( p-SET(pIdx,:) );
        if d < nearDst
            nearDst = d;
            nearIdx = pIdx;
        end
    end   
end