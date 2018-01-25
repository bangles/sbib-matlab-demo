% equivalent function to gluUnProject.
% given a point in window space and a set of transformation matrixes, 
% returns a point in object space
function p_obj = mygluUnProject( p_window, modelview, projection, viewport );

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

p_window_hom = [p_window(1), p_window(2), p_window(3), 1 ];
p_obj_hom = inv_view*inv_proj*inv_mode  *  p_window_hom';

p_obj = p_obj_hom / p_obj_hom(4);
p_obj = p_obj(1:3);