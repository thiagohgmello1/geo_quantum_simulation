function iter = iterative_consts()
% Constants related to iterative process
    iter = struct();
    iter.conv.eta = 1e-4;
    iter.conv.self_e_stop = 1e-4;
    iter.conv.rho_tol = 1e-4;
    iter.conv.recurrent_rho = 2;
    iter.conv.max_iter = 200;
    iter.conv.e = 0.05;
    iter.conv.delta_volt = 1e-4;
    iter.current.v_points = 1;
end