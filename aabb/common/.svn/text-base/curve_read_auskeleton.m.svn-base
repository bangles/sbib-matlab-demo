% Reads a curve-skeleton stored in Oscar Au skeleton extraction by mesh
% contraction format into a curve structure S
function S = curve_read_auskeleton(filename)

% Open file
fid = fopen(filename);
if fid == -1
    error(['ERROR: could not open file "' filename '"']);
end

TEMP = textscan(fid, '%f', 1);
S.vertices = zeros( TEMP{1}, 3 );
S.ADJ = sparse( TEMP{1}, TEMP{1} ); % adjecency matrix
S.DST = sparse( TEMP{1}, TEMP{1} ); % pairwise distances (nothing if not connected)

% parse the file
counter = 0;
while(feof(fid) ~= 1)
    % get next line
    line = fgetl(fid);
    % skip blank line
    if isempty(line), continue; end
    % update counter
    counter = counter + 1;
    % read the three coordinates
    [tok, line] = strtok( line ); %#ok<STTOK>
    S.vertices(counter,1) = str2double( tok );
    [tok, line] = strtok( line ); %#ok<STTOK>
    S.vertices(counter,2) = str2double( tok );
    [tok, line] = strtok( line ); %#ok<STTOK>
    S.vertices(counter,3) = str2double( tok );
    
    % read the connections
    while ~isempty(line)
        [tok, line] = strtok( line ); %#ok<STTOK>
        neigh = str2double( tok )+1; %remove 0-indexing
        if strcmp(tok,'')
            continue;
        end
        S.ADJ(counter,neigh) = 1;
        S.ADJ(neigh,counter) = 1;
        
        % euclidean distances
        dst = norm3( S.vertices(counter,:), S.vertices(neigh,:) );
        S.DST( counter, neigh ) = dst;
        S.DST( neigh, counter ) = dst; 
    end
end

fclose( fid );