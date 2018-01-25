% reads a black and white image and returns its contour.
% the image is assumed to be a solid with disk topology!!
function c_0 = contour_read_bw( filename )

BW = imread( filename );
BW = BW(:,:,1);
BW = double( BW/max(BW(:)) );

% extract the contour
c_0 = contourc( BW, [0.5,0.5] )';
numel = c_0(1,2);
c_0(1,:) = [];

if size(c_0,1) > numel
    error('This function assumes topology 0 isocontour');
end

c_0(end,:)=[];    