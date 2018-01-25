% myedit creates a function stub from the template defined in template.m
% 
% Syntax:
% myedit( filname )
%
% See also:
% template.m
function myedit( filename )

if nargin == 0
    error('specify file/function name');
elseif filename(end) == 'm' || filename(end-1) == '.'
    error('provide function name without extension')
end

% Open template file
fid = fopen('template.m');
% convert file in a stream of characters
funcTemplate = fread(fid, 'uint8=>char');
% Close Template file
fclose(fid);
% make sure it is a row vector
stringtemplate = funcTemplate(:)';

%%%%%%%%% MACRO DEFINITION %%%%%%%%%%
macros{1} = '$filename$';
tokens{1} = filename;
macros{2} = '$creationdate$';
tokens{2} = sprintf('%s', datestr(now, 21) );
macros{3} = '$author$';
tokens{3} = 'Andrea Tagliasacchi';
macros{4} = '$email$';
tokens{4} = sprintf('%s%s',char(java.lang.System.getProperty('user.name')), '@cs.sfu.ca');
macros{5} = '$year$';
tokens{5} = datestr(now, 10);
macros{6} = '$FILENAME$';
tokens{6} = upper(filename);

%%%%%%%%% MACRO SUBSTITUTIONS %%%%%%%%%%
% replace strings like macros{i} with the content of tokens{i}
for i=1:length(macros)
    stringtemplate= strrep(stringtemplate, macros{i}, tokens{i});
end 
    
%%%%%%%%% CREATION OF OUTPUT %%%%%%%%%%
fid = fopen( strcat(filename,'.m'),'w' );
fwrite( fid, stringtemplate,'char');
fclose( fid );

% Open the new m-file
edit( filename );
