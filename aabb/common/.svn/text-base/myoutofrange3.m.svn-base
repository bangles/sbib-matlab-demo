function delp = myoutofrange3(A,siz)
% indexes to be deleted
delp = zeros(size(A,1),1);

% set delp(i)=1 if index in A is out of siz range
for d=1:size(A,2)
   delp = delp | (    A(:,d)<1   );
   delp = delp | ( A(:,d)>siz(d) );
end