% checks if variable exists and not empty
function pred = myexist(varname)
    assert( ischar(varname) );
    
    % checks if P exists in caller domain
    pred = evalin('caller', sprintf('exist(''%s'',''var'');',varname));
    
    if pred==false
        return;
    else
        pred = evalin('caller', sprintf('~isempty(%s);',varname));
        return;
    end
end