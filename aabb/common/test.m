% is the upper index bound re-evaluated at every 
% loop? NO ;)
a = 10;
for i=1:a
    a = a-1;
    disp(i);
end

i=1;
a=10;
while i<a
    a = a-1;
    disp(i);
    i = i + 1;
end