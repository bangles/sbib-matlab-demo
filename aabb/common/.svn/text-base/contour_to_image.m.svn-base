function [I,EN] = contour_to_image( C, delta )

[Pmin, Pmax] = curve_bbox( C );
% simple function to convert pixels idxs to coordinates
ijTOxy = @(ij)( Pmin + (ij-1).*delta + delta/2);
% simple function to coordinates to pixel indexes
xyTOij = @(p)( floor((p-Pmin)./delta)+1 );
% number of pixels
Nij = xyTOij( Pmax )-1;

I = zeros( Nij );
EN = zeros( Nij(1), Nij(2), 2 );
pixDiagSz = sqrt(2)*delta/2;
for v1i=1:length(C.vertices)
    if v1i == length(C.vertices)
        v2i = 1;
    else
        v2i = v1i+1;
    end
    
    ij1 = xyTOij( C.vertices(v1i,:) );
    ij2 = xyTOij( C.vertices(v2i,:) );
    
    % compute local bounding box
    min_ij = [ min( [ij1(1), ij2(1)] ), min( [ij1(2), ij2(2)] ) ];
    max_ij = [ max( [ij1(1), ij2(1)] ), max( [ij1(2), ij2(2)] ) ];
    
    x1 = C.vertices(v1i,:);
    x2 = C.vertices(v2i,:);
            
    for i=min_ij(1):max_ij(1)
        for j=min_ij(2):max_ij(2)
            % compute line distance using eq(16) from:
            % http://mathworld.wolfram.com/Point-LineDistance2-Dimensional.html
            pix_xy = ijTOxy([i,j]);
            linedist = abs( det( [x2-x1; x1-pix_xy] ) ) / norm2(x2,x1);
            if linedist < pixDiagSz
                I(i,j) = 1;
                EN(i,j,:) = vector_perpendicular( vector_normalize(x2-x1) );
            end
        end
    end    
end