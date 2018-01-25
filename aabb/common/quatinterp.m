% SLERP interpolation between two quaternions
function q = quatinterp( q1, q2, t )
    
% theta = acos( real( dot(q1,quatconj(q2)) ) );
theta = acos( q1(1)*q2(1)+dot(q1(2:end),q2(2:end) ) );

% interpolating between same quaternion....
if abs( theta ) < 1e-10
    q = q1;
    return;
end

alpha = sin( (1-t)*theta )/sin( theta );
beta = sin( t*theta )/sin( theta );
q = alpha*q1 + beta*q2;

% normalize quaternion
q = quatnormalize( q );
