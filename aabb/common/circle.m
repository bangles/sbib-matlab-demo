% CIRCLE( c, r );
% Creates a 2D circles as a segmented line of N components 
% with center C and radius R 
function X = circle( C, R, N )
	if ~exist('N','var')
		N = 100;
	end;
	
	theta = linspace(0, 2*pi, N);
	x = C(1) + R.*cos( theta );
	y = C(2) + R.*sin( theta );
	X = [x,y]
% 	plot(x, y)