function setglobal(varname, value) %#ok<INUSD>
    assert( ischar(varname) );
    % caller gets global variable too
    evalin('caller',sprintf('global %s;',varname));
    % global is setup in setglobal's scope
    eval(sprintf('global %s;',varname));
    eval(sprintf('%s=value;', varname));
end
