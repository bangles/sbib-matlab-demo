% equivalent function to gluProject.
% given a point in object space and a set of transformation matrixes, 
% returns a point in window space
function p_win = mygluProject( p_obj, modelview, projection, viewport );

inv_mode = inv( modelview );
if ~exist('projection','var')
    inv_proj = eye(4);
else
    inv_proj = inv( projection );
end;
if ~exist('viewport','var')
    inv_view = eye(4);
else
    inv_view = inv( viewport );
end

p_obj_hom = [p_obj(1), p_obj(2), p_obj(3), 1 ];
p_obj_hom = inv_view*inv_proj*inv_mode  *  p_obj_hom';

p_win = p_obj_hom / p_obj_hom(4);
p_win = p_win(1:3);