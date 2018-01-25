% Usage:
%   - square_phi( p, l, SIZE )
%   - square_phi( p, l, X, Y )
% 
% Example: 
%   - imagesc( square_phi( [.5,.5], .25, [640,480] )<0 );
function F = square_phi( varargin )

switch nargin
    case 0
        clc;
        SIZE = [100,100];
        X = linspace(0,1,SIZE(1));
        Y = linspace(0,1,SIZE(2));
        [x,y] = meshgrid(X,Y);
        varargin{1} = [.5,.5];
        varargin{2} = .25;
    case 3
        SIZE = varargin{3};
        X = linspace(0,1,SIZE(1));
        Y = linspace(0,1,SIZE(2));
        [x,y] = meshgrid(X,Y);
    case 4
        x = varargin{3};
        y = varargin{4};
end

p = varargin{1};
l = varargin{2};

%------------------------------------
% square corners
p1 = p + [-l,-l];
p2 = p + [+l,-l];
p3 = p + [+l,+l];
p4 = p + [-l,+l];       

% convert in halfspaces
v1 = p2-p1; v1 = [v1(2),-v1(1)];
v2 = p3-p2; v2 = [v2(2),-v2(1)];
v3 = p4-p3; v3 = [v3(2),-v3(1)];
v4 = p1-p4; v4 = [v4(2),-v4(1)];
o1 = -v1*p1';
o2 = -v2*p2';
o3 = -v3*p3';      
o4 = -v4*p4';      

% create implicit function halfspaces
F1 = v1(1).*x + v1(2).*y + o1;
F2 = v2(1).*x + v2(2).*y + o2;
F3 = v3(1).*x + v3(2).*y + o3;            
F4 = v4(1).*x + v4(2).*y + o4;


F = funmin(funmin(F1,F2), funmin(F3,F4));
imagesc(F), hold on, contour(F,[0,0],'-y');

function M = funmin(f1,f2)
    sel = (f1)>(f2);
    M = f1.*sel + f2.*(1-sel);
    