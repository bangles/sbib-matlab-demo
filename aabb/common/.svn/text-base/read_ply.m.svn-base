% PCLOUD_READ_PLY('path_to_ply_file')
% OUTPUT
%   - P: a structure with the following fields:
%       - P.v:  the [Nx3] matrix containing point locations
%       - P.n: the [Nx3] matrix containing point normals
%

% Copyright (c) 2008 Andrea Tagliasacchi
% All Rights Reserved
% email: ata2@cs.sfu.ca 
% $Revision: 1.0$  Created on: 2008/08/05
function P = read_ply( filename )

P = struct();
P.bbox = Box3();

h = txtwaitbar('init', 'reading PLY file: ');

% Open file
fid = fopen(filename);
if fid == -1
    error(['ERROR: could not open file "' filename '"']);
end

% spin until end of header
hasViewinfo = false;
line = fgetl(fid);
while ~strcmp( line, 'end_header' );
    line = fgetl(fid);
    % disp(line); % DEBUG
    if length(line)>14 && strcmp( line(1:14), 'element vertex' )
        N = str2double( line(15:end) );
        P.v  = zeros( N, 3 );
        P.n = zeros( N, 3 );
        P.d = zeros( N, 3 );
    end
    
    % does view info exist?
    if length(line)>16 && strcmp( line(1:17), 'property float vx' )
        hasViewinfo = true;
    end
end

% Read content
for pIdx=1:size(P.v,1)
    line = fgetl(fid);
    if line == -1
        disp('error?');
        break;
    end
    if hasViewinfo
       line_data = sscanf(line, '%f %f %f %f %f %f %f %f %f')';
       P.v(pIdx, :) = line_data(1:3);
       P.n(pIdx,:) = line_data(4:6);
       P.d(pIdx,:) = line_data(7:9);

    % use normal as if it was view direction
    else
       line_data = sscanf(line, '%f %f %f %f %f %f %f %f %f')';
       P.v(pIdx, :) = line_data(1:3);
       P.n(pIdx, :) = line_data(1:3);
       P.d(pIdx,:)  = line_data(4:6);
    end
    
    %--- Compute data bounding box
    % null-normal samples don't participate in BBOX
    if ~all( P.n(pIdx,:)==0 )
        P.bbox.add( P.v(pIdx,:) );
    end
    
    h = txtwaitbar( pIdx/size(P.v,1), h );
end

% Close file and waitbar
fclose(fid);
txtwaitbar('close',h);