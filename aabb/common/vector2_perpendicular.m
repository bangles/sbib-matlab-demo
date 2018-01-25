% creates the perpendicular of a vector, rotating it CLOCKWISE in the X-Y axis of 90degrees
function vn = vector2_perpendicular( v )
    if numel(v) ~= 2, error('works only with dim 2 vectors'); end
    vn( 1 ) = v( 2 );
    vn( 2 ) = -v( 1 );
