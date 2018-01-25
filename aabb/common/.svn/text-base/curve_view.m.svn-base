function h_out = curve_view( C )

% setup
h = gca;
hold on;
 
set( h,'Position',[0 0.05 1 1-0.05 ] );
set( h,'YDir','normal')
% do not give output if not requested
if nargout == 0
    h_out = [];
else
    h_out = h;
end

%%%%%%%%%%%%%%%%%%%%%%%% menu setup %%%%%%%%%%%%%%%%%%%%%%%%%%%%
menu_view = uimenu('Label','View');
    uimenu( menu_view,'Label','View Normals','Callback',@view_normals_callback);
    uimenu( menu_view,'Label','View Indexes','Callback',@view_indexes_callback);
    uimenu( menu_view,'Label','View Samples','Callback',@view_samples_callback);
    
menu_tools = uimenu('Label','Tools');
    uimenu( menu_tools,'Label','Pick Point', 'Callback', @point_pick_callback);
    uimenu( menu_tools,'Label','Snapshot', 'Callback', @snapshot_callback);


% if it's not a cell array make it into one (for conveniency)
% so that the type is uniform

% if ~iscell(C)
%     oldC = C;
%     C = cell(1,1);
%     C{1} = oldC;
% end

% if it's a close curve
% if ~iscell(C)
%     verts = [ C.vertices; C.vertices(1,:) ]; 
% end
    
% save status variables
h_curves  = draw_curves();   setappdata(h,'h_curves',h_curves);
h_samples = draw_samples();  setappdata(h,'h_samples',h_samples);
h_normals = draw_normals();  setappdata(h,'h_normals',h_normals);
h_indexes = draw_indexes();  setappdata(h,'h_indexes',h_indexes);

% set drawing limits and vis setup
[Pmin, Pmax] = curve_bbox( C );
padding = 0.1*max(Pmax-Pmin);

xlim([Pmin(1)-padding,Pmax(1)+padding]);
ylim([Pmin(2)-padding,Pmax(2)+padding]);
axis equal
axis off

%%%%%%%%%%%%%%%%%%%%%%%% MENU CALLBACKS %%%%%%%%%%%%%%%%%%%%%%%%
function view_normals_callback( IGNORE1, IGNORE2 ) %#ok<INUSD>
    if strcmp( get( h_normals, 'Visible' ), 'on' );
        set( h_normals, 'Visible', 'off' )
    else
        set( h_normals, 'Visible', 'on' )
    end
end

function view_indexes_callback( IGNORE1, IGNORE2 ) %#ok<INUSD>
    if strcmp( get( h_indexes, 'Visible' ), 'on' );
        set( h_indexes, 'Visible', 'off' )
    else
        set( h_indexes, 'Visible', 'on' )
    end
end

function view_samples_callback( IGNORE1, IGNORE2 ) %#ok<INUSD>
    if strcmp( get( h_samples, 'Visible' ), 'on')
        set( h_samples, 'Visible', 'off' )
    else
        set( h_samples, 'Visible', 'on' )
    end
end

function point_pick_callback( IGNORE1, IGNORE2 ) %#ok<INUSD>
    current_point = get( get(h,'parent'),'currentpoint' );
    disp( current_point );
end

function snapshot_callback( IGNORE1, IGNORE2 ) %#ok<INUSD>
    outfilename = sprintf('results/snapshot_%s_%s', datestr(now,'ddmmyy'), datestr(now,'HHMMss') );
    print('-dpng', outfilename);
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DRAWING CALLBACKS %%%%%%%%%%%%%%%
function h_curves = draw_curves()
    h_curves = [];
    % draw every edge
    for i=1:size(C.edges,1)
        v1 = C.edges(i,1);
        v2 = C.edges(i,2);
        h_curves(end+1) = myedge(C.vertices(v1,:), C.vertices(v2,:)); %#ok<AGROW>
    end
end

function h_samples = draw_samples()
    h_samples = scatter( C.vertices(:,1), C.vertices(:,2), '.r', 'LineWidth', .1 ); %#ok<AGROW>
    set( h_samples, 'Visible', 'off' );
end

function h_normals = draw_normals()   
    h_normals = [];
    for i=1:length(C)
        if ~isfield( C(i), 'VN' );
            h_normals = [];
            return
        end
        
        for j=1:size( C(i).vertices )
            h_normals(end+1) = myline( C(i).vertices(j,:), C(i).VN(j,:), .1); %#ok<AGROW>
            set( h_normals(end), 'linewidth', 1.5 );
            set( h_normals(end), 'color', 'green' );
        end
    end
    set( h_normals, 'Visible', 'off' );
end

function h_indexes = draw_indexes()
    h_indexes = zeros( length(C), 1 );
    if length(C) == 1
        for j=1:size(C(1).vertices)
            h_indexes(end+1) = text( C(1).vertices(j,1), C(1).vertices(j,2), sprintf(' %d',j) ); %#ok<AGROW>
        end
    else
        for i=1:length(C)
            for j=1:size(C(i).vertices)
                h_indexes(end+1) = text( C(i).vertices(j,1), C(i).vertices(j,2), sprintf(' %d_{%d}',j,i) ); %#ok<AGROW>
            end
        end        
    end
    set( h_indexes, 'Visible', 'off' )
end

end % END OF CURVELAB