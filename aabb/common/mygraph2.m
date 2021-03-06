% plots a curve graph in the current axis
%
function h = mygraph2( CG, varargin )
%#ok<*UNRCH>
DEBUG_MODE = false;
if DEBUG_MODE
    warning('DEBUG_MODE==true'); 
    clc, clear, close all;
    load mygraph2_demo.mat CG;
    mygraph2( CG, '-b'); 
end

%--- compute edges on the fly
if isfield(CG,'viv')
    CG.edges = graph_viv_to_edges( CG ); 
end

if isfield(CG,'edges')
    V_FR = CG.vertices( CG.edges(:,1), : );
    V_TO = CG.vertices( CG.edges(:,2), : );
    XX = [V_FR(:,1), V_TO(:,1)]';
    YY = [V_FR(:,2), V_TO(:,2)]';
    h = plot( XX, YY, varargin{:} );

elseif isfield(CG,'adj')
    ADJ = triu(CG.adj);
    [Is,Js] = find(ADJ); %< non-zeros
    V_FR = CG.vertices( Is, : );
    V_TO = CG.vertices( Js, : );
    XX = [V_FR(:,1), V_TO(:,1)]';
    YY = [V_FR(:,2), V_TO(:,2)]';
    h = plot( XX, YY, varargin{:} );
end
