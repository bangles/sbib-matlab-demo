function I = mysub2ind3( SIZE, sub )
    assert( size(sub,2) == 3 );
    I = sub2ind( SIZE, sub(:,1), sub(:,2), sub(:,3) );
    