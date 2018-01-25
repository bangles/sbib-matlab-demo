clc, clear, close all;
% M1 = mesh_read_off('chicken_view1.off');
% M2 = mesh_read_off('chicken_view2.off');
% save input.mat
% load input.mat


% generate data to non-rigid ICP align
[x,y] = pol2cart( linspace(0,2*pi,100), linspace(1,1,100) );
ellipse1 = [x;.1*y]';
ellipse2 = ellipse1;
R = makehgtform('zrotate', pi/20); R = R(1:2,1:2); 
ellipse1 = (R*ellipse1')';
rIdxs = find( ellipse2(:,1)>0 );
R = [0.8660   -0.5000 ; 0.5000    0.8660];
% ellipse2(rIdxs,:) = (R*ellipse2(rIdxs,:)')';
ellipse1(:,3) = 0; ellipse1(end,:) = [];
ellipse2(:,3) = 0; ellipse2(end,:) = [];


% figure, movegui('east'); hold on
% mypoint2( ellipse1, '.r' );
% mypoint2( ellipse2, '.g' );
% axis equal
ellipse2_reg = icp( ellipse1, ellipse2, 10, 1 );
% mypoint2( ellipse2_reg, '*g' );



 