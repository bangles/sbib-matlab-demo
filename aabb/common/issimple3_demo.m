clc, clear, close all
I = imread('issimple2_demo.png');
I = double(I);
I = I(:,:,1); I = 1-I/max(I(:));

% Create a 3-slice volume with the image in the middle slice
V = zeros(size(I, 1), size(I, 2), 3);
V(:, :, 2) = I;

figure;
imagesc(I)
colormap gray
axis off
axis square
hold on

tic;
for i=find( V==1 )'
   if issimple3_mex(V,i) 
      [x,y] = ind2sub(size(I), i-prod(size(I)));
      mypoint2([y,x],'*r');
   end
end
toc


% Create a 3-slice volume with the image in the middle slice
V = zeros(size(I, 1), size(I, 2), 3);
V(:, :, 1) = ones(size(I, 1), size(I, 2));
V(:, :, 2) = I;
V(:, :, 3) = ones(size(I, 1), size(I, 2));

figure;
imagesc(I)
colormap gray
axis off
axis square
hold on

tic;
for i=find( V==1 )'
   if issimple3_mex(V,i) 
       ind = i-prod(size(I));
       if ind < prod(size(I))
          [x,y] = ind2sub(size(I), ind);
        end
      mypoint2([y,x],'*r');
   end
end
toc
