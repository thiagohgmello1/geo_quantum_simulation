function iter = iterative_consts()
    iter = struct();
    iter.counter = 1;
    iter.V_diff = inf;
    iter.V_prev = 0;
end