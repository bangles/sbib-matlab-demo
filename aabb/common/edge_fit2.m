% given a set of samples in 2D space, 
% returns the start and end points of an 
% edge which fits the data in least square sense
% 
% xy is supposed to contain the sameples, a Nx2 
% matrix, where every row is a sample
% 
% the function works on an explicit model, 
% thus requiring the line to be with bounded
% slope coefficient
function [e1, e2] = edge_fit2( xy )

% DEBUG/TEST data
% load edge_fit2.mat xy

A = [xy(:,1), ones(size(xy,1),1)];
b = xy(:,2);
x = A\b;
m = x(1);
q = x(2);

% direction of the line
d = [1,m];
d = d/norm(d);

% choose point on the line
p0 = [0,q];

% compute projection parameter for each point
ts = (xy(:,1)-p0(1)) * d(1) + (xy(:,2)-p0(2)) * d(2);

% extract the two endpoints
t_min = min( ts );
t_max = max( ts );

e1 = p0 + d*t_min;
e2 = p0 + d*t_max;

if 0
    myedge2( e1, e2 );
    clf, figure(1), axis square
    mypoint2(xy,'.r');
end