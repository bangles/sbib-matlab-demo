clc, clear, close all
I = imread('issimple2_demo.png');
I = double(I);
I = I(:,:,1); I = 1-I/max(I(:));

figure;
imagesc(I)
colormap gray
axis off
axis square
hold on

tic;
S = zeros( size(I) );
R1 = zeros( size(I) );
for i=find( I==1 )'
   if issimple2(I,i) 
      [x,y] = ind2sub(size(I), i);
      R1(y, x) = 1;
      mypoint2([y,x],'*r');
   end
end
toc


figure;
imagesc(I)
colormap gray
axis off
axis square
hold on

tic;
S = zeros( size(I) );
R2 = zeros( size(I) );
for i=find( I==1 )'
   if issimple2_mex(I,i) 
      [x,y] = ind2sub(size(I), i);
      R2(y, x) = 1;
      mypoint2([y,x],'*r');
   end
end
toc

norm(R1(:) - R2(:))
