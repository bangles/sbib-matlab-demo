function newv = contour_resample( C, M, TYPE )

newv = zeros( M, 3 );

if ~exist('TYPE', 'var')
    TYPE = 'linear-uniform';
end

% autofunction to access cyclic coordinates
cyidx = @(i,N)( mod( i-1, N ) + 1 );

if strcmp('linear-nonuniform', TYPE)
    newvers(:,1) = interp( [C(:,1);C(1,1)], M );
    newvers(:,2) = interp( [C(:,2);C(1,2)], M );    
    % need to remove the "pseudo" sample inserted at the end
    % which after interpolation takes up M spaces
    newv= newvers( 1:(end-M), : );

elseif strcmp(TYPE,'linear-uniform')

    % allocate output data, M is the number of desired 
    % samples
    new = zeros(M, 2);   
    
    % final sample padding
    C = [C;C(1,:)];
    N = size( C, 1 );
    
    % compute cumulative distances
    D = zeros(1,N);
    for i=1:N
        from = C( cyidx(i+0,N), : );
        to   = C( cyidx(i+1,N), : );
        D(i+1) = sqrt( sum( (from-to).^2 ) );
    end;
    d = cumsum( D );

        
    % compute samples along path
    DISTANCES = 0 : d(end)/M : d(end);
       
    for i=1:M
        currd = DISTANCES(i);
        iPrev = find( d > currd, 1 ) - 1;
        iNext = iPrev + 1;
        % disp( sprintf( 'i:%.0f - %.2f %d %d', i, currd, iPrev, iNext) );
        t = ( currd - d(iPrev) ) / ( d(iNext) - d(iPrev) );
        new(i,:) = C(iPrev,:) + t*( C(iNext,:)-C(iPrev,:) );
    end;
        
    newv = new;
end;
