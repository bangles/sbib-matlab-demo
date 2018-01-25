function D = norm2( A, B )
    % D = sqrt( sum( (A - B).^2 ) ) ; %slower than other
    D = sqrt( (A(1)-B(1))^2 + (A(2)-B(2))^2 ) ;