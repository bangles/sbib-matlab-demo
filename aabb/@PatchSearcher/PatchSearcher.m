classdef PatchSearcher < handle
    properties (SetAccess = private, Hidden = true)
        PTR; % Handle to the underlying C++ class instance
    end
        
    methods
        %--- Constructor
        function this = PatchSearcher(M)
            assert(nargin==1);
            % the data structure is built for "fat" matrixes and C++ zero based indexing!!
            this.PTR = PatchSearcher.mex_build(M.vertices', M.faces'-1);
        end
        %--- destructor (frees memory)
        function delete(this)
            PatchSearcher.mex_delete(this.PTR);
        end        
    end
    
    %--- Methods        
    methods
        function [footpoints, findex, barycoords] = nn(this,query)
            % query points must be provided in one indexing
            [footpoints, findex, barycoords] = PatchSearcher.mex_nn(this.PTR,query');
            footpoints = footpoints';
            barycoords = barycoords';            
            findex = findex + 1; % recover one indexing
        end
    end
    
    %--- Static methods        
    methods(Static)
        compile();
        [footpoints, findex, barycoords] = mex_nn(PTR,query);
        PTR = mex_build(vertices, faces);
        mex_delete(PTR);
    end
end