function M = mesh_read_obj(filename)

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
    if line(1) == 'v', vnum=vnum+1; end;
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

while(feof(fid) ~= 1)
    line = fgetl(fid);
    if isempty(line), continue; end

        % example: "v .1 .2 .3 0"
        if line(1) == 'v' 
            line = line(3:end);
            data = sscanf(line, '%f %f %f');
            M.vertices(vcount, :) = data(1:3);
            vcount = vcount + 1;
            
        % example: "f 1 2 3"
        elseif line(1) == 'f'
            line = line(3:end);
            M.faces(fcount, :) = sscanf(line, '%d %d %d');           
            fcount = fcount + 1;
        end
end

% Close file
fclose(fid);