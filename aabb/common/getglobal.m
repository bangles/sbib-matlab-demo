function value = getglobal(varname,defaultvalue)
    assert( ischar(varname) );
    eval(sprintf('global %s;',varname));
    
    % when no default value provided, variable 
    % MUST have been pre-declared
    if nargin==1    
        assert(~isempty(varname)); 
        eval(sprintf('value = %s;',varname));
    end
    
    % if it was not declared but it has a default
    if nargin==2
        eval(sprintf('value = %s;',varname));
        if isempty(value)
            value = defaultvalue;
        else
            eval(sprintf('value = %s;',varname));
        end
    end
end
