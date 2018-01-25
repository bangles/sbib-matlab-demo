clc, clear, close all;

DEMO_ID = 2;
switch DEMO_ID
   case 1
      I=[ 1  1  1; 0  1  1; 1  0  1; ];
      G=conncomp(I,'2D_4','2D_8');
   
   case 2
      I=zeros(3,3,3);
      I(:,:,1)=[ 1  0  0; 0  1  1; 0  0  1; ];
      I(:,:,2)=[ 0  0  0; 0  1  1; 0  0  1; ];
      I(:,:,3)=[ 1  0  0; 0  0  1; 0  0  1; ];
%        G=conncomp(I,'3D_6');
       G=conncomp(I,'3D_18','3D_26');
%       G=conncomp(I,'3D_26');
end

% 2D visualization
if size(I,3)==1
   figure(1)
      movegui northeast
      imagesc(I); 
      axis off
      axis equal
      colormap(gca, 'gray');
   figure(2)
      movegui east
      imagesc(G); 
      axis off
      axis equal 
      colormap(gca,'lines'); 
      caxis([0 64]);
end

% 3D visualization
if size(I,3)==3
   figure(1)
      movegui northeast
      subplot(131), imagesc(I(:,:,1)); axis off, axis equal
      subplot(132), imagesc(I(:,:,2)); axis off, axis equal
      subplot(133), imagesc(I(:,:,3)); axis off, axis equal
      colormap(gca, 'gray');
   figure(2)
      movegui east
      subplot(131), imagesc(G(:,:,1)); axis off, axis equal, caxis([0 64])
      subplot(132), imagesc(G(:,:,2)); axis off, axis equal, caxis([0 64])
      subplot(133), imagesc(G(:,:,3)); axis off, axis equal, caxis([0 64])
      colormap(gca,'lines');
end