function myimagesc(varargin)
% slices a volume automatically before displaying
if ndims( varargin{1} ) == 3
    I = varargin{1};
    I = I(:,:,round(end/2));
% 
else
    I = varargin{1};
end
imagesc(I,varargin{2:end});