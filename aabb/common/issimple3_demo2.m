I = [0 0 0 0 0;
     0 1 1 1 0;
     0 1 0 1 0;
     0 1 1 1 0;
     0 0 0 0 0];
I2 = [0 0 0 0 0;
     0 1 1 1 0;
     0 1 1 1 0;
     0 1 1 1 0;
     0 0 0 0 0];
V = zeros(5, 5, 2);
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
title('Adjacent slices are all zeros');

V(:, :, 1) = I2;
V(:, :, 3) = I2;

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
title('Adjacent slices are all ones');
