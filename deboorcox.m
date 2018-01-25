function N = deboorcox(i,k,u,U)
    if k == 1
        if u >= U(i+1) && u < U(i+2), N = 1; return; end
        if u == U(i+2) && u == 1.0, N = 1; return; end
        N = 0; return;
    end
    N = 0;
    if U(i+k) ~= U(i+1)
        N = N + (u - U(i+1)) / (U(i+k) - U(i+1)) * deboorcox(i,k-1,u,U);
    end
    if U(i+k+1) ~= U(i+2)
        N = N + (U(i+k+1)-u) / (U(i+k+1)-U(i+2)) * deboorcox(i+1,k-1,u,U);
    end
end