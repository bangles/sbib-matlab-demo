clc, clear, close all;
figure(1), hold on;
xlim([-1.5, 1.5]);
ylim([-1.5, 1.5]);
axis equal

n=[0,0,-1];
theta = 0;          q_0 = [cos(theta/2), sin(theta/2)*n]; 
theta = pi/2;       q_1 = [cos(theta/2), sin(theta/2)*n]; 
theta = pi-.001;    q_2 = [cos(theta/2), sin(theta/2)*n]; 
p = 1.0*[1,0,0];
q = 0.9*[1,0,0];
r = 0.8*[1,0,0];

ts = linspace( 0,1,100 );
for t = ts
    curr_q = quatinterp( q_0, q_1, t );
    p_tr = quatrotate( curr_q, p );
    mypoint3( p_tr, '.r' );
    
    curr_q = quatinterp( q_1, q_2, t );
    q_tr = quatrotate( curr_q, q );
    mypoint3( q_tr, '.g' );
     
    curr_q = quatinterp( q_0, q_2, t );
    r_tr = quatrotate( curr_q, r );
    mypoint3( r_tr, '.b' );
    pause(.01);
end