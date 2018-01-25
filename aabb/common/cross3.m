% cross product between 3D vectors
function V = cross3( V1, V2 )
	V = [ V1(2)*V2(3) - V1(3)*V2(2); V1(3)*V2(1) - V1(1)*V2(3); V1(1)*V2(2) - V1(2)*V2(1) ];
