% PLANE_BBOX_INTERSECTION short description
% Copyright (c) 2008 Andrea Tagliasacchi
% All Rights Reserved
% email: ata2@cs.sfu.ca 
% $Revision: 1.0$  Created on: 2008/08/04
function [predicate] = plane_bbox_intersection( Pp, Np, BBOX )

global TH_ZERO;

hasAbove = false;
hasBelow = false;
predicate = false;

if isempty( TH_ZERO )
    TH_ZERO = 1e-4;
end

% for every point of the bounding box check on which side of the plane 
% they reside using the plane equation <(X - Pp), Np> = 0
for xi=1:2 
    for yi=1:2
        for zi=1:2
            P = [ BBOX(xi,1), BBOX(yi,2), BBOX(zi,3) ];
            side = dot_product( P - Pp, Np );
            
            % box point is tangent
            if abs(side) < TH_ZERO
                predicate = true;
                return
            
                % box point is above
            elseif side >= 0
                hasAbove = true;
                
            % box point is below
            elseif side <= 0 
                hasBelow = true;
            end
            
            % exit condition
            if hasAbove && hasBelow 
                predicate = true;
                return
            end
        end
    end
end
