% Legacy: replaced by mex call
function trace_ray_slow(this, ray, startat, field1, field2)
   curr_p = ray.p(startat);
   curr_i = this.pos2off(curr_p);
   microdelta = this.delta / 10;
   while ~isnan( curr_i(1) )
      % in first we save weight field            
      this.grids.(field1)(curr_i(1),curr_i(2),curr_i(3)) = 1;

      % in second we save signed distance field (clamp'd)
      pixpos = this.off2pos( curr_i );
      % offset real distance by the "startat" amount. This
      % is because we do not want to get closer than "startat"
      t = dot( pixpos-ray.o, ray.d ) + startat;

      % lower the upper bound deterministically
      % here would be better to use a soft-min
      if t < this.grids.(field2)(curr_i(1),curr_i(2),curr_i(3))
          this.grids.(field2)(curr_i(1),curr_i(2),curr_i(3)) = t;
      end

      % DEBUG
%             mypoint2(curr_i,'.r');
%             mypoint2(this.pos2offd(curr_p),'.g');
%             pause(.05);

      % increment
      curr_p = curr_p + microdelta*ray.d;
      curr_i = this.pos2off(curr_p);
   end
end