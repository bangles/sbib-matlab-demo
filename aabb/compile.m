function compile()
    localpath = fileparts(which('compile'));
    fprintf(1,'Compiling library [%s]...\n', localpath);

    inputs = {'mex_build.cpp', 'mex_delete.cpp', 'mex_nn.cpp'};
    for i=1:numel(inputs)
        err = mex('-I/usr/local/include', ...
              '-I../eigen/', ...,
              '-L/usr/lib/x86_64-linux-gnu/', ...
              '-lCGAL', '-lboost_thread', '-lboost_system', ...
              '-outdir', [localpath, '/@PatchSearcher/'], [localpath,'/@PatchSearcher/',inputs{i}]);
        if err ~= 0 
            error('compile failed!'); 
        end
    end    
end