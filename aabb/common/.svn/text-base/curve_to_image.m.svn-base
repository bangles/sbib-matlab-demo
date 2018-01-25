% converts a curve (edges+vertices) to an image in which I==1
% in regions where the edges cross a pixel
function [I,ijTOxy,xyTOij] = curve_to_image( C, delta )

[Pmin, Pmax] = curve_bbox( C );
ijTOxy = @(ij)( Pmin + (ij-1).*delta + delta/2);
xyTOij = @(p)( floor((p-Pmin)./delta)+1 );
Nij = xyTOij( Pmax )-1;

I = zeros( Nij );
pixDiagSz = sqrt(2)*delta/2;
for eIdx=1:length(C.edges)
    v1i = C.edges(eIdx,1);
    v2i = C.edges(eIdx,2);
    xy1 = C.vertices(v1i,:);
    xy2 = C.vertices(v2i,:);
    ij1 = xyTOij( xy1 );
    ij2 = xyTOij( xy2 );
    
    % compute local bounding box
    min_ij = [ min( [ij1(1), ij2(1)] ), min( [ij1(2), ij2(2)] ) ];
    max_ij = [ max( [ij1(1), ij2(1)] ), max( [ij1(2), ij2(2)] ) ];
            
    for i=min_ij(1):max_ij(1)
        for j=min_ij(2):max_ij(2)
            % compute line distance using eq(16) from:
            % http://mathworld.wolfram.com/Point-LineDistance2-Dimensional.html
            % norm of the cross product is projected distance
            pix_xy = ijTOxy([i,j]);
            linedist = abs( det( [xy2-xy1; xy1-pix_xy] ) ) / norm2(xy2,xy1);
            if linedist < pixDiagSz
                I(i,j) = 1;
            end
        end
    end    
end