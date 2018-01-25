
% checks whether locally the removal of the current pixel would 
% cause a change in topology or not
function retval = issimple2(phi, I) %#ok<*INUSD>

% create some phony 2D data
[x,y] = ind2sub(size(phi),I);

% WHY IS THIS HAPPENING?
if x<=1 || y<=1 || x+1>size(phi,1) || y+1>size(phi,2)
   warning('out of bounds');
   retval = false;
   return;
end
   
% extract a local 3-block
A = phi(x-1:x+1, y-1:y+1);
% compute opposite of component
An = 1-A;
% number of 8 connected components in I = 1
ni = conncomp(A,'2D_8','full');
% number of 4 connected components in \neg{I} = 1
no = conncomp(An,'2D_4','2D_4');

retval = ni==1 && no==1;