% curve is assumed "counterclockwise"
function Cout = contour_flip_insideout( C )
    Cout = flipud( C.vertices );