% DEFAULTVALUE c-like "defaulting" parameters routine
%
% SYNTAX
% [ variable_value ] = defaultvalue( fuction_varargin, argin_index, default_value )
%
% INPUT PARAMETERS
%   function_varargin: the variable arguments of the function which variables we are checking
%   argin_index:       the index of the paraeter which default value we are checking
%   default_value:     the default value to give the paraeter
%
% OUTPUT PARAMETERS
%   variable_value:    the original value of the parameter or its defaulted version if undefined
%
% DESCRIPTION
% Given a vararg representation of the inputs argument, checks wheter 
% the i-th varargin input variable is defined. If it's not defined or
% its value is empty, the function associates to it its "default" value.
% Indicating "default_value == null" means that the parameter MUST be assigned a value and
% that an error indicating this problem will be returned
% 
% Examples:
% This example illustrate a function inside which defaultvalue is used to
% default the values of its parameters.
% 
% See also:
% DEFAULTVALUE_DEMO, DEFAULTVALUE_DEMO_2
% 

% Copyright (c) 2008 Andrea Tagliasacchi
% All Rights Reserved
% email: ata2@cs.sfu.ca 
% $Revision: 1.0$  Created on: 2008/09/23
function [ new_variable ] = defaultvalue( myvarargin, index, def_value )

% that parameter wasn't even given
if index > length(myvarargin)
    if isnan(def_value)
        throwAsCaller(MException('COMMON:DEFAULT', '%d-th parameter need to have a value in the calling function\n', index));
    else
        new_variable = def_value;
    end

% that parameter was given
else
    % but it was an empty value
    if isempty( myvarargin{index} )
        if isnan(def_value)
            throwAsCaller(MException('COMMON:DEFAULT', 'the %d-th parameter need to have a value in the calling function\n', index));
        else
            new_variable = def_value;
        end
    else
        new_variable = myvarargin{index};
    end
end
    
end %end of defaultvalue
