function iter = iterative_consts()
    iter = struct();
    iter.conv.eta = 1e-4;
    iter.conv.self_e_stop = 1e-4;
    iter.conv.rho_tol = 1e-4;
    iter.conv.max_iter = 100;
    iter.conv.e = 0.05;
    iter.current.v_points = 10;
end