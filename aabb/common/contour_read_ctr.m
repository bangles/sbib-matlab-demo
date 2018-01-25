function C = contour_read_ctr( filename )

%--- open file and check for format
fid= fopen( filename );
if fid == -1, error(['ERROR: could not open file "' filename '"']); end

%--- create the structure
C = struct();

%--- scan the vertices
% -0.377960 -0.377960 
C.vertices = fscanf( fid,'%f %f ',[2 inf])';

fclose(fid);
    
 