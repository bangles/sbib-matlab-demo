% alternative to patch that supports structs with extra fields
% (i.e. the extra fields simply get discarded)
function p = mypatch(M, varargin)

S.vertices = M.vertices;
S.faces = M.faces;
if isfield(M,'FaceVertexCData')
   S.FaceVertexCData = M.FaceVertexCData;
end

p = patch(S, varargin{:});
