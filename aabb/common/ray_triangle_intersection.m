% [ Copyright ? 2007 Andrea Tagliasacchi - All rights reserved ]
% [ intersectP t ] = intersectRayTriangle( ray_ori, ray_dir, tri_v1, tri_v2, tri_v3 )
% ray: structure
%	position: 3x1 position 
%	direction: 3x1 direction
% triangle: 
function [ intersectP t inext, b1, b2] = ray_triangle_intersection( ray_ori, ray_dir, tri_v1, tri_v2, tri_v3 )
    % init output
	b1 = 0; b2 = 0;
    intersectP = false;
	inext = 0;
	t = 0;
	MINT = 0;
	MAXT = 1;
	
	% triangle side vectors
	e1 = tri_v2 - tri_v1;
	e2 = tri_v3 - tri_v1;
	s1 = cross(ray_dir, e2);
	divisor = dot(s1, e1);
	
	if divisor == 0.0
		return
	end
	invDivisor = 1.0 / divisor;
	
	% Compute first barycentric coordinate
	d = ray_ori - tri_v1;
	b1 = dot(d, s1) * invDivisor;
	if (b1 < 0.0 || b1 > 1.0)
		return
	end

	% Compute second barycentric coordinate
	s2 = cross(d, e1);
	b2 = dot(ray_dir, s2) * invDivisor;
	if (b2 < 0. || b1 + b2 > 1.)
		return
    end
	
    
	% Compute t to intersection point
	t = dot(e2, s2) * invDivisor;
    % disp(sprintf('within face, t=%f', t));
	if ( t < MINT || t > MAXT )
		intersectP = false;
		return
	else
		intersectP = true;
		% compute closest vertice
		intP = ray_ori + t*ray_dir;
		[IGNORE, inext] = min( [sum((intP-tri_v1).^2), sum((intP-tri_v2).^2), sum((intP-tri_v3).^2)] );
	end
