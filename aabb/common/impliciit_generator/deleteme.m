clc, clear, close all;

I = zeros( 640,640 );

xx = linspace(0,1,640);
yy = linspace(0,1,640);
[x,y] = meshgrid(xx,yy);

test = 'square';
switch test
    case 'circle'
        % F: (X-X0)^2 - R^2 = 0
        % X: (x,y)
        % X0: (x0,y0)

        %origin of circle
        x0 = .2;
        y0 = .2;
        % radius of circle
        R = .1;
        % create an implicit function
        F = (x-x0).^2 + (y-y0).^2 - R^2;

        % convert implicit function to in/out
        I( F<0 ) = 1;
        I( F>=0 ) = 0;
        
    case 'triangle'
        % triangle corners
        p1 = [.2,.2];
        p2 = [.8,.1];
        p3 = [.25,.7];
        
        % convert in halfspaces
        v1 = p2-p1; v1 = [v1(2),-v1(1)];
        v2 = p3-p2; v2 = [v2(2),-v2(1)];
        v3 = p1-p3; v3 = [v3(2),-v3(1)];
        o1 = -v1*p1';
        o2 = -v2*p2';
        o3 = -v3*p3';      
       
        % create implicit function halfspaces
        F1 = v1(1).*x + v1(2).*y + o1;
        F2 = v2(1).*x + v2(2).*y + o2;
        F3 = v3(1).*x + v3(2).*y + o3;            

        % take union of halfspaces
        I = (F1<0) & (F2<0) & (F3<0);
        
    case 'square'
        % square
        p = [.5 .5];
        l = .2;       
        
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

        % take union of halfspaces
        I = (F1<0) & (F2<0) & (F3<0) & (F4<0);
end
    


imshow(I)