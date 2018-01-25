function curve_write_cg( C, curve_filename )




fid = fopen(curve_filename, 'w');

if isfield(C,'edges')
    fprintf(fid, '# D:%d NV:%d NE:%d\n', size(C.vertices,2), size(C.vertices,1), size(C.edges,1) );
    for i=1:length(C.vertices)
        fprintf(fid,'v %f %f\n', C.vertices(i,:));
    end
    for i=1:length(C.edges)
        fprintf(fid,'e %d %d\n', C.edges(i,:));
    end
    
% graph in adjecency matrix
elseif isfield(C,'ADJ')
    nedges = 0;
    for i=1:size(C.ADJ,1)
        for j=i+1:size(C.ADJ,2)
            if C.ADJ(i,j) == 1, nedges = nedges+1; end
        end
    end
    fprintf(fid, '# D:%d NV:%d NE:%d\n', size(C.vertices,2), size(C.vertices,1), nedges );
    for i=1:length(C.vertices)
        fprintf(fid,'v %f %f %f\n', C.vertices(i,:));
    end
    
    
    for i=1:size(C.ADJ,1)
        for j=i+1:size(C.ADJ,2)
            if C.ADJ(i,j) == 1
                fprintf(fid,'e %d %d\n', i, j);
            end
        end
    end    
end

fclose(fid);