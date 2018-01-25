clear

%% 3D example
clc;
v1 = rand( 3, 1 );
v2 = rand( 1, 3 );
m1 = rand( 10,3 );
m2 = rand( 10,3 );
d1 = dot_product( v1, m1 )
d2 = dot_product( m2, v1 )
d3 = dot_product( m1, m2 )
d4 = dot_product( v1, v2 )

%% 2D example
clc;
v1 = rand( 2, 1 );
v2 = rand( 1, 2 );
m1 = rand( 10,2 );
m2 = rand( 10,2 );
d1 = dot_product( v1, m1 )
d2 = dot_product( m2, v1 )
d3 = dot_product( m1, m2 )
d4 = dot_product( v1, v2 )

%% mixed example (robustness)
clc;
v1 = rand( 2, 1 );
v2 = rand( 1, 3 );
m1 = rand( 10,2 );
m2 = rand( 10,3 );
% d1 = dot_product( v1, m2 ) % => error
% d2 = dot_product( m2, v1 ) % => error
% d3 = dot_product( m1, m2 ) % => error
% d4 = dot_product( v2, m1 ) % => error
% d5 = dot_product( m1, v2 ) % => error

%% check performances
clc
N = 1000;
v1 = rand( 3, 1 );
m1 = rand( 100000,3 );
times1 = zeros( N, 1 );
times2 = zeros( N, 1 );
times3 = zeros( N, 1 );
for n=1:N
    tic
    dot_product( v1, v1 );
    times1( n ) = toc;
       
    tic
    dot_product( v1, m1 );
    times2( n ) = toc;

    tic
    dot_product( m1, m1 );
    times3( n ) = toc;
end
disp( sprintf( 'vector-vector average time %d', mean(times1) ) );
disp( sprintf( 'vector-matrix average time %d', mean(times2) ) );
disp( sprintf( 'matrix-matrix average time %d', mean(times3) ) );