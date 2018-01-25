% written on 24 Feb 2010
function mesh_write_ply(M, filename)

% DEBUG RUN
if nargin==0
    clc
    filename = 'deleteme.ply';
    M.vertices = 1*[eye(3); eye(3)];
    M.normals  = 2*[eye(3); eye(3)];
    M.viewdirs = 3*[eye(3); eye(3)];
    M.vquality = [.1*(1:6)]';
end


%---------------------------------------------------------------
%                              OPEN 
%---------------------------------------------------------------
fid = fopen(filename,'w');
if fid==-1, error(['ERROR opening file: "' filename '"']); end

%---------------------------------------------------------------
%                             HEADER 
%---------------------------------------------------------------
%--- OPEN UP
fprintf(fid, 'ply\n');
fprintf(fid, 'format ascii 1.0\n');

%--- ELEMENT VERTEX
fprintf(fid, 'element vertex %d\n', size(M.vertices,1) );
if isfield(M,'vertices')
    fprintf(fid, 'property float x\n');
    fprintf(fid, 'property float y\n');
    fprintf(fid, 'property float z\n');
else
    error('M has no .vertices?');
end
if isfield(M,'vquality')
    fprintf(fid, 'property float quality\n');
end
if isfield(M,'vcolor')
    assert( size(M.vcolor,2)>=3 );
    assert( all(all(M.vcolor>=0  )) );
    assert( all(all(M.vcolor<=255)) );
    assert( size(M.vcolor,1)==size(M.vertices,1) );
    assert( size(M.vcolor,2)==3 );
    M.vcolor = round(M.vcolor);
    fprintf(fid, 'property uchar red\n');
    fprintf(fid, 'property uchar green\n');
    fprintf(fid, 'property uchar blue\n');
    % conditionally add alpha
    if size(M.vcolor,2)==4
        fprintf(fid, 'property uchar alpha\n');
    end
end

if isfield(M,'vnormals')
    fprintf(fid, 'property float nx\n');
    fprintf(fid, 'property float ny\n');
    fprintf(fid, 'property float nz\n');
end
if isfield(M,'viewdirs')
    fprintf(fid, 'property float texture_u\n');
    fprintf(fid, 'property float texture_v\n');
    fprintf(fid, 'property float texture_w\n');
end

%--- ELEMENT FACE
if isfield(M,'faces')
    fprintf(fid, 'element face %d\n', size(M.faces,1) );
    fprintf(fid, 'property list uchar int vertex_indices\n' );
end
%--- CLOSE UP
fprintf(fid, 'end_header\n');


%---------------------------------------------------------------
%                             DATA
%---------------------------------------------------------------

%--- VERTEX DATA
% write vertice data (same order of header)
if isfield(M,'vertices')
    % float fields
    MAT = M.vertices;
    if isfield(M,'vquality'), MAT = [MAT, M.vquality]; end
    if isfield(M,'vnormals'), MAT = [MAT, M.vnormals]; end
    if isfield(M,'viewdirs'), MAT = [MAT, M.viewdirs]; end
    format1 = repmat('%f ',[1,size(MAT,2)]);

    % char fields (need tweaking to add more...)
    if isfield(M,'vcolor')
        MAT = [ MAT, M.vcolor ];
        format2 = repmat('%d ',[1,size(M.vcolor,2)]);
        format = [format1,format2,'\n'];
        fprintf(fid, format, MAT');
    else
        format = [format1,'\n'];
        fprintf(fid, format, MAT');
    end
end
%--- FACE DATA
if isfield(M,'faces')
    MAT = M.faces-1; % ply are 0-indexed
    MAT = [3*ones(size(M.faces,1),1),MAT]; % triangles
    format = repmat('%d ',[1,size(MAT,2)]);
    format = [format,'\n'];
    fprintf(fid, format, MAT');
end

%---------------------------------------------------------------
%                            CLOSE 
%---------------------------------------------------------------
fclose(fid);