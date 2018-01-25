function newv = mesh_addnoise(M,TYPE,delta)
assert(nargin==3);

if ~isscalar(delta)
    if ischar(delta)
        if delta(end)=='%'
            bbox = Box3(M.vertices);
            delta = bbox.diag() * str2num( delta(1:end-1) ) / 100;
        end
    end
end

if isempty(TYPE)
    TYPE = 'isotropic'; 
end
    
switch TYPE
    case 'isotropic'
        newv = M.vertices + delta*randn( size(M.vertices) ); 
end