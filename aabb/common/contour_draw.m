% contour_create( filename, size_x, size_y, image_filename )
% 
% filename:       output filename for created data
% size_x:         width of the drawing window
% size_y:         height of the drawing window
% image_filename: an image visualized in the background
%                 which can be used to guide your drawing
%
function contour_draw( filename, size_x, size_y, image_filename )
% %%% DEBUG INPUT DATA
% filename = 'cangaroo.ctr';
% size_x = [];
% size_y = [];
% image_filename = 'images/cangaroo.png';
% %%%

if ~exist('filename', 'var')
    filename = 'contour.ctr';
end;
if exist('image_filename', 'var')
    I = imread(image_filename);
    size_x = size(I,1);
    size_y = size(I,2);
else
    I = zeros( size_x, size_y );
% else
%      size_x = 400;
%     size_y = 400;
end 
if ~exist('size_x', 'var')
    size_x = 400;
end;
if ~exist('size_y', 'var')
    size_y = 400;
end;

h = figure; 
disp('RULES:');
disp(' - click to add point to contour');
disp(' - click on first point to finish contour by closing it');
disp(' - right click to finish without closing');
disp(' - double click inside the coutour to finish and save the file');
[MASK, xi, yi] = roipoly( I );
delete( h );

% normalize (turned off)
if 0
    xi = -xi/size_x;
    yi = yi/size_y;
else
    xi = -xi;
    yi = yi;    
end
c = [xi, yi];
    
% save to file 
C.vertices = c;
contour_write_ctr(filename,C);