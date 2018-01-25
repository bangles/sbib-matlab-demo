function trace_rays_compile()

localpath = fileparts(which('trace_rays_compile'));
fprintf(1,'Compiling trace_rays_MEX[%s]...\n', localpath);

% first filename gives name of mex file
err = mex('-outdir',localpath, ...
          '-output','trace_rays_MEX', ...
          '-g',...
          [localpath,'/trace_rays_MEX.cpp']);       
       
if err ~= 0
   return
else
   fprintf(1,'\bDone!\n');
end