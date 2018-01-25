function contour_write_ctr(filename, C)
c = C.vertices;
n = C.VN;

% save to file 
fid = fopen( filename,'w');

hasnormals = isfield( C, 'VN' );
    
for i=1:size( c, 1 )
    if(hasnormals)
        fprintf( fid, '%.4f %.4f %.4f %.4f\n', c(i,1), c(i,2), n(i,1), n(i,2) );
    else
        fprintf( fid, '%.4f %.4f\n', c(i,1), c(i,2) );
    end
end

fclose(fid);