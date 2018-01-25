clc, clear;
A = zeros( 10,10 );
A( 6,5 )  = 1;
A( 7,10 ) = 1;
[x,y] = max2( A );