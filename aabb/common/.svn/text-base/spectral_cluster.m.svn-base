function Y = spectral_cluster(M, k)
%SPECT_CLUSTER Spectral clustering
%    function C = spect_cluster(M, k)
%        C = assigned clusters
%        M = similarity matrix
%        k = number of clusters to be created


% Create affinity matrix
avg = mean2(M);
for i = 1:size(M, 1)
    for j = 1:size(M, 2)
        A(i, j) = exp(-M(i, j)/avg);
    end
end

% Create diagonal matrix
D = zeros(size(M, 1), size(M, 2));
for i = 1:size(M, 1)
    s = 0;
    for j = 1:size(M, 2)
        s = s + A(i, j);
    end
    D(i, i) = 1.0/sqrt(s);
end

% Normalize affiniy matrix
A = D*A*D;

% Get eigenvectors
[evc, evl] = eig(A);

% Get k largest eigenvectors
X = evc(:,1:k);

% Normalize rows of X matrix
Y = zeros(size(X, 1), size(X, 2));
for i = 1:size(X, 1)
    s = 0;
    for j = 1:size(X, 2)
        s = s + X(i, j)^2;
    end
    s = sqrt(s);
    for j = 1:size(X, 2)
        Y(i, j) = X(i, j)/s;
    end
end