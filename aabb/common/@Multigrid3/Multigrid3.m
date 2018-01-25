classdef Multigrid3 < handle
    properties (SetAccess = public)
        vols = {}
    end

    methods
        function this = Multigrid3( size, bbox, numlevels, fieldnames )
            %--- checks dim is a power of two
            % assert( rem(log2(size),1)==0 );
            %--- checks field names is string or struct of strings
            assert( ischar(fieldnames) | iscellstr(fieldnames) );
            %--- size of largest scale grid
            curr_size = size;
            for i=numlevels:-1:1
                this.vols{i} = Volume3(curr_size,bbox,fieldnames);
                curr_size = curr_size/2;
            end
        end

        function nl = numlevels(this)
            nl = length(this.vols);
        end

        function display(this)
            frmt = '%5s %5s %10s %13s %25s %25s';
            title = sprintf(frmt, 'level', 'status', 'delta', 'size', 'bbox.pMin', 'bbox.pMax');
            disp( title );
            title(:) = '-';
            disp( title );
            for i=1:length(this.vols)
                s0 = sprintf('%d',i);
                s1 = sprintf('%d',this.vols{i}.isInit);
                s2 = sprintf('%.2f',this.vols{i}.delta);
                s3 = sprintf('%d %d %d', this.vols{i}.size );
                s4 = sprintf('[%.2f %.2f %.2f]', this.vols{i}.bbox.pMin );
                s5 = sprintf('[%.2f %.2f %.2f]', this.vols{i}.bbox.pMax );
                line = sprintf(frmt, s0,s1,s2,s3,s4,s5);
                disp( line );
            end
        end
    end
end