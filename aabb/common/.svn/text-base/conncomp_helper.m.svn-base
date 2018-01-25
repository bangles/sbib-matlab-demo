function blabla()
clc, clear, close all;

%--------------------------------------------------------------------------
%                        26 connectivity matrix (3D)
%--------------------------------------------------------------------------
mydisp('\n--- 26 Connectivity (3D) ---')
phi = zeros(3,3,3);
for i=1:length(phi(:)), phi(i) = ind2sub(size(phi),i); end
% phi 

for i=1:length(phi(:))
   % only accept neighbors in current 3x3
   ineighs = neighs_26(i, phi);
   ineighs = sort(ineighs);
   
   % example: N{1} = [2,4,5];
   fprintf(1,'N{%d} = [',i); 
   for j=1:length(ineighs)
      fprintf(1,'%d',ineighs(j));
      if(j<length(ineighs)), fprintf(1,', '); end
   end
   fprintf(1,'];\n');
end

function ineighs = neighs_26(I,phi)
   S = size(phi);
   [x,y,z] = ind2sub(size(phi), I);
   ineighs = zeros(1,26);  %row as to be used in for loop
   % The same ones we had in N18
   try      ineighs(1)  = sub2ind(S, x+1, y  , z  );     catch ignore, ineighs( 1) = 0; end
   try      ineighs(2)  = sub2ind(S, x-1, y  , z  );     catch ignore, ineighs( 2) = 0; end
   try      ineighs(3)  = sub2ind(S, x  , y+1, z  );     catch ignore, ineighs( 3) = 0; end
   try      ineighs(4)  = sub2ind(S, x  , y-1, z  );     catch ignore, ineighs( 4) = 0; end
   try      ineighs(5)  = sub2ind(S, x  , y  , z+1);     catch ignore, ineighs( 5) = 0; end 
   try      ineighs(6)  = sub2ind(S, x  , y  , z-1);     catch ignore, ineighs( 6) = 0; end
   try      ineighs(7)  = sub2ind(S, x+1, y+1, z  );     catch ignore, ineighs( 7) = 0; end 
   try      ineighs(8)  = sub2ind(S, x-1, y+1, z  );     catch ignore, ineighs( 8) = 0; end
   try      ineighs(9)  = sub2ind(S, x+1, y-1, z  );     catch ignore, ineighs( 9) = 0; end 
   try      ineighs(10) = sub2ind(S, x-1, y-1, z  );     catch ignore, ineighs(10) = 0; end
   try      ineighs(11) = sub2ind(S, x+1, y  , z+1);     catch ignore, ineighs(11) = 0; end 
   try      ineighs(12) = sub2ind(S, x+1, y  , z-1);     catch ignore, ineighs(12) = 0; end 
   try      ineighs(13) = sub2ind(S, x-1, y  , z+1);     catch ignore, ineighs(13) = 0; end
   try      ineighs(14) = sub2ind(S, x-1, y  , z-1);     catch ignore, ineighs(14) = 0; end
   try      ineighs(15) = sub2ind(S, x  , y+1, z+1);     catch ignore, ineighs(15) = 0; end 
   try      ineighs(16) = sub2ind(S, x  , y+1, z-1);     catch ignore, ineighs(16) = 0; end
   try      ineighs(17) = sub2ind(S, x  , y-1, z+1);     catch ignore, ineighs(17) = 0; end 
   try      ineighs(18) = sub2ind(S, x  , y-1, z-1);     catch ignore, ineighs(18) = 0; end
   % extremal corners
   try      ineighs(19) = sub2ind(S, x-1, y-1, z-1);     catch ignore, ineighs(19) = 0; end   
   try      ineighs(20) = sub2ind(S, x-1, y-1, z+1);     catch ignore, ineighs(20) = 0; end   
   try      ineighs(21) = sub2ind(S, x-1, y+1, z-1);     catch ignore, ineighs(21) = 0; end   
   try      ineighs(22) = sub2ind(S, x-1, y+1, z+1);     catch ignore, ineighs(22) = 0; end   
   try      ineighs(23) = sub2ind(S, x+1, y-1, z-1);     catch ignore, ineighs(23) = 0; end   
   try      ineighs(24) = sub2ind(S, x+1, y-1, z+1);     catch ignore, ineighs(24) = 0; end   
   try      ineighs(25) = sub2ind(S, x+1, y+1, z-1);     catch ignore, ineighs(25) = 0; end   
   try      ineighs(26) = sub2ind(S, x+1, y+1, z+1);     catch ignore, ineighs(26) = 0; end
   
   ineighs( ineighs==0 ) = [];
end

return




%--------------------------------------------------------------------------
%                        18 connectivity matrix (3D)
%--------------------------------------------------------------------------
mydisp('\n--- 18 Connectivity (3D) ---')
phi = zeros(3,3,3);
for i=1:length(phi(:)), phi(i) = ind2sub(size(phi),i); end
% phi 

for i=1:length(phi(:))
   % only accept neighbors in current 3x3
   ineighs = neighs_18(i, phi);
   ineighs = sort(ineighs);
   
   % example: N{1} = [2,4,5];
   fprintf(1,'N{%d} = [',i); 
   for j=1:length(ineighs)
      fprintf(1,'%d',ineighs(j));
      if(j<length(ineighs)), fprintf(1,', '); end
   end
   fprintf(1,'];\n');
end

function ineighs = neighs_18(I,phi)
   S = size(phi);
   [x,y,z] = ind2sub(size(phi), I);
   ineighs = zeros(1,18);  %row as to be used in for loop
   % The same ones we had in N6
   try      ineighs(1)  = sub2ind(S, x+1, y  , z  );     catch ignore, ineighs( 1) = 0; end 
   try      ineighs(2)  = sub2ind(S, x-1, y  , z  );     catch ignore, ineighs( 2) = 0; end
   try      ineighs(3)  = sub2ind(S, x  , y+1, z  );     catch ignore, ineighs( 3) = 0; end
   try      ineighs(4)  = sub2ind(S, x  , y-1, z  );     catch ignore, ineighs( 4) = 0; end
   try      ineighs(5)  = sub2ind(S, x  , y  , z+1);     catch ignore, ineighs( 5) = 0; end 
   try      ineighs(6)  = sub2ind(S, x  , y  , z-1);     catch ignore, ineighs( 6) = 0; end
   %X-Y plane corners
   try      ineighs(7)  = sub2ind(S, x+1, y+1, z  );     catch ignore, ineighs( 7) = 0; end 
   try      ineighs(8)  = sub2ind(S, x-1, y+1, z  );     catch ignore, ineighs( 8) = 0; end
   try      ineighs(9)  = sub2ind(S, x+1, y-1, z  );     catch ignore, ineighs( 9) = 0; end 
   try      ineighs(10) = sub2ind(S, x-1, y-1, z  );     catch ignore, ineighs(10) = 0; end
   %X-Z plane corners
   try      ineighs(11) = sub2ind(S, x+1, y  , z+1);     catch ignore, ineighs(11) = 0; end 
   try      ineighs(12) = sub2ind(S, x+1, y  , z-1);     catch ignore, ineighs(12) = 0; end 
   try      ineighs(13) = sub2ind(S, x-1, y  , z+1);     catch ignore, ineighs(13) = 0; end
   try      ineighs(14) = sub2ind(S, x-1, y  , z-1);     catch ignore, ineighs(14) = 0; end
   %Y-Z plane corners
   try      ineighs(15) = sub2ind(S, x  , y+1, z+1);     catch ignore, ineighs(15) = 0; end 
   try      ineighs(16) = sub2ind(S, x  , y+1, z-1);     catch ignore, ineighs(16) = 0; end
   try      ineighs(17) = sub2ind(S, x  , y-1, z+1);     catch ignore, ineighs(17) = 0; end 
   try      ineighs(18) = sub2ind(S, x  , y-1, z-1);     catch ignore, ineighs(18) = 0; end   

   ineighs( ineighs==0 ) = [];
end



%--------------------------------------------------------------------------
%                         8 connectivity matrix
%--------------------------------------------------------------------------
mydisp('\n--- 8 Connectivity ---')
phi = [
   1 4 7;
   2 5 8;
   3 6 9;
   ];
for i=1:9
   % only accept neighbors in current 3x3
   ineighs = neighs_8(i, phi);
   ineighs = sort(ineighs);
   
   % example: N8{1} = [2,4,5];
   fprintf(1,'N8{%d} = [',i); 
   for j=1:length(ineighs)
      fprintf(1,'%d',ineighs(j));
      if(j<length(ineighs)), fprintf(1,', '); end
   end
   fprintf(1,'];\n');
end

function ineighs = neighs_8(I,phi)
   S = size(phi);
   [x,y] = ind2sub(size(phi), I);
   ineighs = zeros(1,8);  %row as to be used in for loop
   try      ineighs(1) = sub2ind(S, x+1, y   );     catch ignore, ineighs(1) = 0; end 
   try      ineighs(2) = sub2ind(S, x-1, y   );     catch ignore, ineighs(2) = 0; end
   try      ineighs(3) = sub2ind(S, x  , y+1 );     catch ignore, ineighs(3) = 0; end
   try      ineighs(4) = sub2ind(S, x  , y-1 );     catch ignore, ineighs(4) = 0; end
   try      ineighs(5) = sub2ind(S, x+1, y+1 );     catch ignore, ineighs(5) = 0; end 
   try      ineighs(6) = sub2ind(S, x-1, y-1 );     catch ignore, ineighs(6) = 0; end
   try      ineighs(7) = sub2ind(S, x-1, y+1 );     catch ignore, ineighs(7) = 0; end
   try      ineighs(8) = sub2ind(S, x+1, y-1 );     catch ignore, ineighs(8) = 0; end
   ineighs( ineighs==0 ) = [];
end



%--------------------------------------------------------------------------
%                        6 connectivity matrix (3D)
%--------------------------------------------------------------------------
mydisp('\n--- 6 Connectivity (3D) ---')
phi = zeros(3,3,3);
for i=1:length(phi(:)), phi(i) = ind2sub(size(phi),i); end
% phi 

for i=1:length(phi(:))
   % only accept neighbors in current 3x3
   ineighs = neighs_6(i, phi);
   ineighs = sort(ineighs);
   
   % example: N{1} = [2,4,5];
   fprintf(1,'N{%d} = [',i); 
   for j=1:length(ineighs)
      fprintf(1,'%d',ineighs(j));
      if(j<length(ineighs)), fprintf(1,', '); end
   end
   fprintf(1,'];\n');
end

function ineighs = neighs_6(I,phi)
   S = size(phi);
   [x,y,z] = ind2sub(size(phi), I);
   ineighs = zeros(1,4);  %row as to be used in for loop
   try      ineighs(1) = sub2ind(S, x+1, y  , z  );     catch ignore, ineighs(1) = 0; end 
   try      ineighs(2) = sub2ind(S, x-1, y  , z  );     catch ignore, ineighs(2) = 0; end
   try      ineighs(3) = sub2ind(S, x  , y+1, z  );     catch ignore, ineighs(3) = 0; end
   try      ineighs(4) = sub2ind(S, x  , y-1, z  );     catch ignore, ineighs(4) = 0; end
   try      ineighs(5) = sub2ind(S, x  , y  , z+1);     catch ignore, ineighs(5) = 0; end 
   try      ineighs(6) = sub2ind(S, x  , y  , z-1);     catch ignore, ineighs(6) = 0; end
   ineighs( ineighs==0 ) = [];
end




%--------------------------------------------------------------------------
%                         4 connectivity matrix
%--------------------------------------------------------------------------
mydisp('\n--- 4 Connectivity ---')
phi = [
   1 4 7;
   2 5 8;
   3 6 9;
   ];
for i=1:9
   % only accept neighbors in current 3x3
   ineighs = neighs_4(i, phi);
   ineighs = sort(ineighs);
   
   % example: N4{1} = [2,4];
   fprintf(1,'N4{%d} = [',i); 
   for j=1:length(ineighs)
      fprintf(1,'%d',ineighs(j));
      if(j<length(ineighs)), fprintf(1,', '); end
   end
   fprintf(1,'];\n');
end

% I = x + y*X
function ineighs = neighs_4(I, phi)  
   S = size(phi);
   [x,y] = ind2sub(size(phi), I);
   ineighs = zeros(1,4);  %row as to be used in for loop
   try      ineighs(1) = sub2ind(S, x+1, y   );     catch ignore, ineighs(1) = 0; end 
   try      ineighs(2) = sub2ind(S, x-1, y   );     catch ignore, ineighs(2) = 0; end
   try      ineighs(3) = sub2ind(S, x  , y+1 );     catch ignore, ineighs(3) = 0; end
   try      ineighs(4) = sub2ind(S, x  , y-1 );     catch ignore, ineighs(4) = 0; end
   ineighs( ineighs==0 ) = [];
end





end % end of function