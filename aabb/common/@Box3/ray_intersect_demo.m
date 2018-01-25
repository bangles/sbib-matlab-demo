close all; clc, clear; % clear classes;

%--- Create rays on sphere (d==0)
% ray_o = uniform_sample_sphere( 100 ); 
% ray_d = -ray_o;

%--- Create full random rays
ray_o = randn( 100, 3 ); 
ray_d = randn( 100, 3 );
den = ray_d(:,1).^2+ray_d(:,2).^2+ray_d(:,3).^2;
ray_d(:,1) = ray_d(:,1)./den;
ray_d(:,2) = ray_d(:,2)./den;
ray_d(:,3) = ray_d(:,3)./den;

%--- Create bounding box
bbox = Box3();
bbox.addall( ray_o );


figure(1), hold on;
myplot3(ray_o,'.r');

%--- Perform ray-box intersection
for i=1:size(ray_d,1)
    t = bbox.ray_intersect( ray_o(i,:), ray_d(i,:) );
    ray_o(i,:) = ray_o(i,:) + t*ray_d(i,:);
end

%--- check bound satisfaction
% I = find( ~bbox.inbounds(ray_o) );
% myplot3(ray_o(I,:),'*r');
assert( all(bbox.inbounds( ray_o )) )


myplot3(ray_o,'.b');
axis equal