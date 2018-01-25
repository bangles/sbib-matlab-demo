%% Simple progressbar
clc
h = txtwaitbar('init', 'my title');
N = 20;
for i=1:N
  h = txtwaitbar(i/N, h);
  pause(.1)
end
txtwaitbar('close', h);

%% Nested functions
clc, clear global;
% global SKIP_WAITBAR;
% clear SKIP_WAITBAR;
N = 10;
h1 = txtwaitbar('init', 'nest1');
for i=1:N
    h1 = txtwaitbar(i/N, h1);
    h2 = txtwaitbar('init', 'nest2');
    for j=1:N
        h2 = txtwaitbar(j/N, h2);
        pause(.05)
    end
    txtwaitbar('close', h2);
end
txtwaitbar('close', h1);
