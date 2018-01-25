% Reads a curve stored in CurveGraph format into structure C
% [DONE!] now it can read curves embedded in arbitrary dimensions
function C = curve_read_cg( filename )

%--- open file and check for format
fid= fopen( filename );
if fid == -1, error(['ERROR: could not open file "' filename '"']); end

%--- create the structure
C = struct();

%--- scan the header
% # D:2 NV:124 NE:115  
sizes = fscanf( fid,'%*[#] D:%d NV:%d NE:%d\n',[1 3]);

%--- check dimensions
% if sizes(1) ~= 2
%     error('curve_read_cg can only read curves embedded in R^2');
% end    

%--- scan the vertices (number of dimensions arbitrary)
% v -0.377960 -0.377960 
C.vertices = fscanf( fid,['%*[v] ',repmat('%f ',1,sizes(1) ),'\n'],[sizes(1) sizes(2)])';
%--- scan the edges
% e 1 2
C.edges = fscanf( fid,'%*[e] %i %i\n',[2 sizes(3)])';  

fclose(fid);


    
 