function M = mesh_read_meshlab_obj(filename)

% Open file
fid = fopen(filename);
if fid == -1
    error(['ERROR: could not open file "' filename '"']);
end

vnum = 0;
fnum = 0;
while feof(fid)~=1
    line = fgetl(fid);
    if isempty(line), continue; end
    if numel(line)>2 && strcmp(line(1:2),'v '), vnum=vnum+1; end;
    if line(1) == 'f', fnum=fnum+1; end;
end
fclose(fid);
disp(sprintf(''));

M = struct();
M.vertices = zeros(vnum,3);
M.faces = zeros(fnum,3);

fid = fopen(filename);
vcount = 1;
fcount = 1;
ncount = 1;

while(feof(fid) ~= 1)
    line = fgetl(fid);
    if isempty(line), continue; end

    % example: "v 0.1 0.2 0.3"
    if line(1) == 'v' 
        if line(2) ~= 'n'
            line = line(3:end);
            data = sscanf(line, '%f %f %f');
            M.vertices(vcount, :) = data(1:3);
            vcount = vcount + 1;
        else
            line = line(3:end);
            data = sscanf(line, '%f %f %f');
            M.normals(ncount, :) = data(1:3);
            ncount = ncount + 1;
        end

    % example: f 19//19 18//18 4//4
    % Remember OBJ is 1-indexed like matlab
    elseif line(1) == 'f'
        line = line(3:end);
        faceline = sscanf(line, '%d//%d %d//%d %d//%d');
        vidxs = faceline([1,3,5]);
        nidxs = faceline([2,4,6]);
        assert( all(vidxs==nidxs) );
        M.faces(fcount, :) = vidxs;
        fcount = fcount + 1;
    end
end

% Deal only with simple meshes!
assert(ncount == vcount);

% Close file
fclose(fid);