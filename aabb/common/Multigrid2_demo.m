clc, clear, close all, % clear classes;
bbox = Box2( [-8,-8], [+8,+8] );
m = Multigrid2( 8, bbox, 2, {'f'}, 2 );
m.disp();


%-- Tests the indexing across multiple scales
p0 = zeros(100,2)*m.vols{1}.delta;
sigma = 3*m.vols{1}.delta;
p = p0 + (rand(100,2)-.5)*sigma;

% draw point in higher res
figure();
movegui('west');
subplot(121)
vol = m.vols{1};
vol = vol.init_checkerboard('f');
vol.plot('f')
vol.plot_bbox()
vol.plot_bbox(bbox);
mypoint2( vol.pos2off(p), 'og', 'markersize',10 );
mypoint2( vol.pos2offd(p), '.r' );


% draw point in lower res
subplot(122)
vol = m.vols{2};
vol = vol.init_checkerboard('f');
vol.plot('f')
vol.plot_bbox()
vol.plot_bbox(bbox);
mypoint2( vol.pos2off(p), 'og', 'markersize',10 );
mypoint2( vol.pos2offd(p), '.r' );

%--- tests out of range
subplot(121)
p = m.vols{1}.pos2off( m.vols{1}.bbox.pMax+[1,1]*m.vols{1}.delta );
assert( all(isnan(p)) )
mypoint2( p, '.r' );
