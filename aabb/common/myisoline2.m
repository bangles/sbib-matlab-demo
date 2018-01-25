% IN: a 2D scalar field
% OUT: an array of vertices and the connectivity matrix, plus a cell that
% contains every loop independently
%
% it acts as a post-processing of contourc( phi, [isovalue,isovalue] )
% 
% it also re-orders the curves so that they are all clock or anti-clockwise
%
function [phi0_array, viv, phi0_cell] = myisoline2( phi, isovalue, delta, ORDER )
% DEBUGGING
DEBUGGING = false;
if DEBUGGING
    clc, close all;
    %--- Disconnected sets
    % load mycontours2.mat phi
    
    %--- Closeby samples
    load mycontours2.2.mat phi;
    delta = 1;
    
    isovalue = 0;
end

if ~exist('ORDER','var')
    ORDER = [];
end
if ~exist('delta','var')
    delta = 0;
end

phi0 = contourc( phi, [isovalue, isovalue] )';
phi0_array = zeros(0,2);
viv = zeros(0,2);
phi0_cell  = cell(1,0);

% the first length index is in position 1
ilength = 1;
while ilength<size(phi0,1)
    % extract length
    len = phi0(ilength,2);

    % extract set of elements
    currblock  = phi0(ilength+1:ilength+len,:);
    
    % isoline is a loop
    if currblock(1,1) == currblock(end,1) && ...
       currblock(1,1) == currblock(end,1) 
        % delete last line
        currblock(end,:) = [];
    end
    
    %--- Remove points too close to each other
    if delta~=0
        i=1;
        while i<size(currblock,1)-1
            if norm(currblock(i,:)-currblock(i,:))<delta
                currblock(i,:) = []; %delete!!
                % disp('deleted1!!!');
            end
            i = i + 1;
        end
    end
    
    % if required 
    if ~isempty(ORDER) && strcmp(ORDER,'clockwise')==1
        
        % compute centroid
        currblock_M = mean( currblock );
        currblock_m = currblock - repmat( currblock_M, size(currblock,1), 1 );
        % convert to polar coordinates
        angles = cart2pol( currblock_m(:,1), currblock_m(:,2) );
        % compute angle variation
        dangles = diff( angles );
        % compute cumulative variation
        dir = sum( dangles );
        % if anti-clockwise... flip it!!
        if dir > 0,
            currblock = flipud( currblock );
        end
    end
    
    currneighs      = zeros(size(currblock,1),2);
    currneighs(:,1) = [size(currblock,1), 1:size(currblock,1)-1];
    currneighs(:,2) = [2:size(currblock,1), 1];
           
    % concatenate
    viv = [viv; currneighs+size(phi0_array,1)]; %#ok<AGROW>
    phi0_array = [phi0_array; currblock];   %#ok<AGROW>
    phi0_cell{end+1} = currblock; %#ok<AGROW>
    
    % update to visit next block
    ilength = ilength + len + 1;
end

%--- convert neighbors in CurveGraph mode
%    transform every row of neighbors in a cell
% viv = num2cell( viv, 2 );


if DEBUGGING
    plot( phi0_array(:,1), phi0_array(:,2),'.r' )
end