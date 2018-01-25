%MYFIGURE Creates a figure window (by name).
%   MYFIGURE's behavior is very similar to figure. 
%   The first parameter however can be a string instead
%   of a number
%
% Example:
%   instead of calling:
%   >> figure(1)
% 
%   you can now use:
%   >> myfigure('error plot');
%
%   See also SUBPLOT, AXES, GCF, CLF.

%   Copyright 2011 Andrea Tagliasacchi
%   $Revision: 1.0 $  $Date: 2011/05/1 11:03:17 $
function h = myfigure( hash_key, varargin )
global MYFIGURE_FIGHS; 
global MYFIGURE_EXPNUMFIG; % expected number of figures to fill this area
global MYFIGURE_PERC;      % percentage of RHS of the screen used for figures
global MYFIGURE_FIGBORDER; % depends on your OS and your screen size :(

USE_SMART_PLACEMENT = true;
if USE_SMART_PLACEMENT
    % has user specified a setup?
    if strcmp(hash_key,'setup')
        n = numel(varargin);
        if n==3
            MYFIGURE_EXPNUMFIG = varargin{1};
            MYFIGURE_PERC = varargin{2};
            MYFIGURE_FIGBORDER = varargin{3};
        elseif n==2
            MYFIGURE_EXPNUMFIG = varargin{1};
            MYFIGURE_PERC = varargin{2};
            MYFIGURE_FIGBORDER = 12;
        elseif n==1
            MYFIGURE_EXPNUMFIG = varargin{1};
            MYFIGURE_PERC = .3;
            MYFIGURE_FIGBORDER = 12;
        end
        
    % when setup is not specified
    elseif isempty(MYFIGURE_FIGHS)
        MYFIGURE_EXPNUMFIG = 2;
        MYFIGURE_PERC = .2;
        MYFIGURE_FIGBORDER = 12;
    else
        % just reuse the one stored in global
    end        
    
    if isempty(MYFIGURE_FIGHS), MYFIGURE_FIGHS = nan(MYFIGURE_EXPNUMFIG,1); end
end
if strcmp(hash_key,'setup'), return; end;

h = findobj(0, 'Type', 'figure', 'Tag', hash_key );
if isempty(h)
    if USE_SMART_PLACEMENT
        % clean up old figures
        MYFIGURE_FIGHS( ~ishandle(MYFIGURE_FIGHS) ) = nan;
        
        % queries screensize
        scrsz = get(0,'ScreenSize');
        xpos = scrsz(1) + (1-MYFIGURE_PERC)*scrsz(3);
        xsiz = scrsz(3)*MYFIGURE_PERC;
        ysiz = scrsz(4) / MYFIGURE_EXPNUMFIG -MYFIGURE_FIGBORDER;
        numfig = sum( ishandle(MYFIGURE_FIGHS) );
        ypos = (scrsz(4)-numfig*MYFIGURE_FIGBORDER )* (((MYFIGURE_EXPNUMFIG-1) - numfig)/MYFIGURE_EXPNUMFIG);
                
        % generates figure
        pos = [xpos,ypos,xsiz,ysiz];    
        % create figure
        if numfig<MYFIGURE_EXPNUMFIG
            h = figure('Tag', hash_key, 'OuterPosition', pos, varargin{:});
            MYFIGURE_FIGHS(numfig+1) = h;
        else
            h = figure('Tag', hash_key, varargin{:});
        end
    else
        h = figure('Tag', hash_key, varargin{:});
    end
else
    figure(h, varargin{:});
end