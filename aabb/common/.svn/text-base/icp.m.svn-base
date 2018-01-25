function [cloud2_reg, T, quality] = icp(cloud1, cloud2, maxIter, eps, SAMPLING_RADIUS )
% align cloud2 to cloud1 returning alignment transforms

VIEW_PROGRESS = 0;

%--- Default parameters
if ~exist('maxIter','var')
    maxIter = 30;
end
if ~exist('eps','var')
    eps = .1;
end

%--- VISUALIZATION
if VIEW_PROGRESS 
    hf = figure; clf, movegui('east'); hold on
    mypoint3( cloud1, '+r' );
    axis equal
end

%--- cumulative ICP transformation (initially none)
R = eye(3);
t = zeros(3,1);

cloud2_reg = cloud2;
kdtree = kdtree_build( cloud1 );
for i=1:maxIter   
    disp( i );
    
    %--- CORRESPONDENCES (find the corresponding points, not too far!!)
    corr = zeros( 0, 2 );
    for pIdx = 1:length(cloud2)
        % disp(sprintf('%d/%d',pIdx,length(cloud2)));
        [nn,dst] = kdtree_nearest_neighbor(kdtree, cloud2_reg(pIdx,:));
        if dst <= eps
            corr(end+1,:) = [nn,pIdx]; %#ok<AGROW>
        end
    end
    if size(corr,1)<3
        quality = 0;
        T = [];
        return;
    end
        
    % ICRP: e-reciprocal correspondence
%     kdtree2 = kdtree_build( cloud2 );
%     corr = zeros( 0, 2 );
%     for pIdx = 1:length(cloud2)
%         [nn,dst1] = kdtree_nearest_neighbor(kdtree, cloud2_reg(pIdx,:));
%         [nn2,dst] = kdtree_nearest_neighbor(kdtree2, cloud1(nn,:));
%         if dst < maxDst %&& dst1 < maxDst
%             corr(end+1,:) = [nn,pIdx]; %#ok<AGROW>
%         end
%     end

    % TriICP 
%     corr = zeros( length(cloud2), 3 ); 
%     for pIdx = 1:length(cloud2)
%         [nn,dst] = kdtree_nearest_neighbor(kdtree, cloud2_reg(pIdx,:));
%         corr(pIdx,:) = [nn,pIdx,dst]; %#ok<AGROW>
%     end
%     [ ign, idxs ] = sort( corr(:,3) );
%     corr = corr(idxs(1:ceil(eps*length(idxs))), 1:2);
    
    %--- VISUALIZE CORRESPONDENCES   
    if VIEW_PROGRESS
        hpts = mypoint3( cloud2_reg, '.g' );
        hedge = [];
        for cIdx=1:length(corr)
            hedge(end+1) = myedge3( cloud1(corr(cIdx,1),:), cloud2_reg(corr(cIdx,2),:) ); %#ok<AGROW>
        end
        title('iteration1.png');
        gif_add_frame(hf,'icp.gif',1);
        pause(.1);
        if i~=maxIter
            delete( hedge );
            delete( hpts  );
        end
    end
    
    %--- TRANSFORMATION ESTIMATION (from correspondence)
    [new_R, new_T] = reg(cloud1, cloud2_reg, corr);
    
    %--- MORPHING (using estimated transformations)
    for pIdx = 1:length(cloud2)
        cloud2_reg(pIdx,:) = new_R*cloud2_reg(pIdx,:)' + new_T;
    end  
    
%     disp( cloud2_reg );
%     disp( new_R );
%     disp( new_T );
    
    %--- ACCUMULATE TRANSFORMATION
    R = new_R*R;
    t = new_R*t + new_T;
end

% quantify the outcome of the registration
if exist('SAMPLING_RADIUS', 'var')
    % THIS VERSION IS FOR NORMAL ICP
    corr = zeros( 0, 3 );
    for pIdx = 1:length(cloud2)
        [nn,dst] = kdtree_nearest_neighbor(kdtree, cloud2_reg(pIdx,:));
        if dst <= eps
            corr(end+1,:) = [nn,pIdx,dst]; %#ok<AGROW>
        end
    end
    quality = sum(corr(:,3)< SAMPLING_RADIUS)/size(corr,1);
    
    % reject alignment with too little good overlap (<10% of input patch)
    if size(corr,1) < .1*size(cloud2,1)
        quality = 0;
    end
        
    
    % THIS VERSION IS FOR TriICP
%     corr = zeros( length(cloud2), 3 ); 
%     for pIdx = 1:length(cloud2)
%         [nn,dst] = kdtree_nearest_neighbor(kdtree, cloud2_reg(pIdx,:));
%         corr(pIdx,:) = [nn,pIdx,dst]; %#ok<AGROW>
%     end
%     [ ign, idxs ] = sort( corr(:,3) );
%     corr = corr(idxs(1:ceil(eps*length(idxs))), 3);
%     quality = sum(corr < SAMPLING_RADIUS)/length(corr);
else
    quality = 0;
end

kdtree_delete( kdtree );
T = eye(4,4);
T(1:3,1:3) = R;
T(1:3,4) = t;


% This portion of code is extended from the one of Ajmal Saeed Mian 
function [R1, t1] = reg(data1, data2, corr)
    % extract corresponding parts in M and S
    M = data1(corr(:,1),:); 
    mm = mean(M,1);
    S = data2(corr(:,2),:);
    ms = mean(S,1);
    % de-mean the data
    Sshifted = (S - repmat(ms, size(S,1),1))';
    Mshifted = (M - repmat(mm, size(S,1),1))';
    % PCA estimate transformation
    K = Sshifted*Mshifted';
    K = K/length(corr);
    [U A V] = svd(K);
    R1 = V*U';
    if det(R1)<0
        B = eye(3);
        B(3,3) = det(V*U');
        R1 = V*B*U';
    end
    t1 = mm' - R1*ms';