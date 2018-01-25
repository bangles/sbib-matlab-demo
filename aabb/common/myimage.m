function h = myimage( I, Pmin, Pmax )
if nargin>1
    h = imagesc( [Pmin(1), Pmax(1)], [Pmin(2), Pmax(2)], I' );
else
    h = imagesc( I' );
end

set(gca,'YDir','normal'), axis off;