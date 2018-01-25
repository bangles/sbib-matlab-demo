% TRIANGLE_PLANE_INTERSECTION short description
%
% SYNTAX
% [output] = triangle_plane_intersection(M)
%
% INPUT PARAMETERS
%   M: mesh in patch format with the following additional subfields
%       - M.FA:
%       - M.FN:
%
% OUTPUT PARAMETERS
%   output: output description
%
% DESCRIPTION
% intersect a plane with a triangle and returns the two
% resulting intersecting segments.
%
% See also:
% example_triangle_plane_intersection, segment_plane_intersection
%

% Copyright (c) 2008 Andrea Tagliasacchi
% All Rights Reserved
% email: ata2@cs.sfu.ca 
% $Revision: 1.0$  Created on: 2008/07/03
function [P0, P1, type, IDX] = triangle_plane_intersection(V, Pp, Np)
    
    % zero threshold
    global ZEROTH;
    if isempty(ZEROTH)
        ZEROTH = 1e-5;
    end

    % initialize the dummy return data
    P0 = [];
    P1 = [];
    IDX = [];
    type = 0; 
    
    % try intersect every of the three edges with the plane
    for iEdge=0:2
        p0 = V( mod(iEdge,3)+1, : );
        p1 = V( mod(iEdge+1,3)+1, : );
        t = segment_plane_intersection(p0,p1,Pp,Np);
       
        % discriminate over the "t" value
        if ((t+ZEROTH)>0) && ((t-ZEROTH)<1)
            parval(iEdge+1) = t;
        elseif ((t+ZEROTH)<0) || ((t-ZEROTH)>1)
            parval(iEdge+1) = t;
        elseif abs(t)<ZEROTH
            parval(iEdge+1) = 0;
        elseif (1-abs(t))<ZEROTH
            parval(iEdge+1) = 1;
        elseif isnan(t)
            parval(iEdge+1) = NaN; % just inserted a "dummy" value
        end
    end
    
    % extract the subsolutions
    valid_idxs = find( parval > 0 & parval < 1 );
    invalid_idxs = find( parval < 0 | parval > 1 );
    zero_idxs = find( parval == 0 | parval == 1 );
    nan_idxs = find( isnan(parval) | isinf(parval) ); 
    
    %%% DETECT TYPE OF SOLUTION
    % 0) completely invalid intersection
    if length(invalid_idxs) == 3
        %disp('doesnt intersect');
        return
    
    % 1) completely valid intersection
    elseif length(valid_idxs) == 2
        %disp('completely valid intersection');
        P0 = V(mod(valid_idxs(1)-1,3)+1,:)+parval(valid_idxs(1))*(V(mod(valid_idxs(1),3)+1,:)-V(mod(valid_idxs(1)-1,3)+1,:));
        P1 = V(mod(valid_idxs(2)-1,3)+1,:)+parval(valid_idxs(2))*(V(mod(valid_idxs(2),3)+1,:)-V(mod(valid_idxs(2)-1,3)+1,:));
        IDX = mod(valid_idxs-2,3)+1; % this is because the way M.FIFOV works
        type = 1;
        return
    
    % 3/-1) intersection lies on edge or tangent to vertice
    elseif length(zero_idxs) == 2 && ( length(nan_idxs) == 1 || length(invalid_idxs) == 1)
        P0 = V(mod(zero_idxs(1)-1,3)+1,:)+parval(zero_idxs(1))*(V(mod(zero_idxs(1),3)+1,:)-V(mod(zero_idxs(1)-1,3)+1,:));
        P1 = V(mod(zero_idxs(2)-1,3)+1,:)+parval(zero_idxs(2))*(V(mod(zero_idxs(2),3)+1,:)-V(mod(zero_idxs(2)-1,3)+1,:));   
        
        if euclidean_distance(P0, P1) > ZEROTH
            %disp('intersection lies on edge');
            type = 3;
            IDX = zero_idxs(1);
        else
            %disp('intersection lies on vertice');
            type = -1;
            IDX = zero_idxs(1);
        end
    % 2) intersection crosses face and falls on vertice
    elseif length(zero_idxs)==2 && length(valid_idxs)==1
        %disp('intersection crosses face and falls on vertice');
        P0 = V(mod(zero_idxs(1)-1,3)+1,:)+parval(zero_idxs(1))*(V(mod(zero_idxs(1),3)+1,:)-V(mod(zero_idxs(1)-1,3)+1,:));
        P1 = V(mod(valid_idxs(1)-1,3)+1,:)+parval(valid_idxs(1))*(V(mod(valid_idxs(1),3)+1,:)-V(mod(valid_idxs(1)-1,3)+1,:));
        type = 2;
        IDX(1) = valid_idxs;
        IDX(2) = zero_idxs(1);
    end
end %end of triangle_plane_intersection
