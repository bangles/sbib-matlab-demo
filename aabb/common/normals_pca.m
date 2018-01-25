function [normals, neighs] = normals_pca(points)
% NORMALS_PCA Finding normals for points in a point cloud using ordinary PCA.
%
% Input
% - points: Nx3 matrix of points in point cloud.
% Outputs
% - normals: Nx3 matrix of calculated normals.
% - neighs: cell array of K nearest neighbors indexes for each point.

	Knn = 20;
	points_tree = KDTreeSearcher(points);
	neighs = points_tree.knnsearch(points, 'k', Knn);
	neighs = num2cell(neighs,2);
	demeaned = cellfun(@(X)( points(X,:)-repmat(mean(points(X,:)),[numel(X),1]) ), neighs, 'UniformOutput',false);
	covs = cellfun(@(X)( X'*X ), demeaned, 'UniformOutput',false);
	[Us,~,~] = cellfun(@(X)( svd(X'*X) ), demeaned, 'UniformOutput',false);
	normals = cellfun(@(X)(X(:,end)'), Us, 'UniformOutput', false);
	normals = cell2mat(normals);
end