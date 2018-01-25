% Testing whether offset indexing makes a difference
% when used in column or row format... 
% OUTCOME: unfortunately no... you are forced to use linear indexing
clc, clear, close all;

A = zeros(100,100);
B = zeros(100,100);
C = zeros(100,100);
IDXS = floor(rand(100,1)*length(A(:))+1);
[I,J,K] = ind2sub(size(A),IDXS);

A(IDXS) = 1;
B(I,J,K) =1;
C(I',J',K') =1;

subplot(311), imagesc(A);
subplot(312), imagesc(B);
subplot(313), imagesc(C);
