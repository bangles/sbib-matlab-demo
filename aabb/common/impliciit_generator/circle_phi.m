% Usage:
%   - circle_phi( c, r, SIZE )
%   - circle_phi( c, r, X, Y )
% 
% Example: 
%   - imagesc( circle_phi( [.2,.5], .1, [640,480] )<0 );
function F = circle_phi( varargin )

switch nargin
    case 3
        SIZE = varargin{3};
        X = linspace(0,1,SIZE(1));
        Y = linspace(0,1,SIZE(2));
        [x,y] = meshgrid(X,Y);
    case 4
        x = varargin{3};
        y = varargin{4};
end

c = varargin{1};
r = varargin{2};

%------------------------------------
% F: (X-X0)^2 - R^2 = 0
% X: (x,y)
% X0: (x0,y0)

%origin of circle
x0 = c(1);
y0 = c(2);
% radius of circle
R = r;
% create an implicit function
F = (x-x0).^2 + (y-y0).^2 - R^2;