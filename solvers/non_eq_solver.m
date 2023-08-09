function [rho_in, H] = non_eq_solver(G_complete, G, system, model, channel_id,...
    mat, iter, num, mu, gen, Vol, from_id, to_id)
%NON_EQ_SOLVER solve NEGF and Poisson equations self-consistently

    H0 = build_H(G_complete, mat, channel_id);
    G_channel = G_nodes_by_id(G_complete, channel_id);
    
    rho_in = sparse(zeros(numnodes(G_channel)));
    V = sparse(zeros(numnodes(G_channel)));
    U_gate = -1 * sparse(eye(numnodes(G_channel))) * gen.V_gate;
    rho_diff = inf;
    
    counter = 0;
    e = iter.conv.e;
    rho_in1 = 0;
    Fm1 = 0;
    Qm1 = 0;

    while abs(rho_diff) > iter.conv.rho_tol && counter < iter.conv.max_iter
        coulomb_energy = mat.t * rho_in;
        H = H0 + U_gate + coulomb_energy;

%         V_results = poisson_solver(model, gen, Vol, G, mat.a, real(diag(rho_in)));
%         V = calc_V(G_channel, V_results);
        rho_out = calc_density_matrix(G_complete, G_channel, system, H, mu, gen, iter, mat, num, from_id, to_id);
        
        [rho_diff, rho_in1, Fm, Fm1, Qm, Qm1] = conv_acceleration(rho_in, rho_in1, rho_out, Fm1, Qm1, e, counter);
        rho_in = rho_in - e * Fm - Qm * Fm;

        counter = counter + 1;
        disp([rho_diff, num2str(counter)]);
    end

end


function [rho_diff, rho_in1, Fm, Fm1, Qm, Qm1] = conv_acceleration(rho_in, rho_in1, rho_out, Fm1, Qm1, e, counter)
    Fm = diag(rho_out - rho_in);

    if counter > 0
        delta_Fm = Fm - Fm1;
        VmT = delta_Fm' / (delta_Fm' * delta_Fm);
        Um = -e * delta_Fm + diag(rho_in) - diag(rho_in1) - Qm1 * delta_Fm;
        Qm = Qm1 + Um * VmT;
    else
        Qm = 0;
    end
    
    rho_diff = real(max(diag(rho_out - rho_in) ./ diag(rho_in)));
    rho_in1 = rho_in;
    Qm1 = Qm;
    Fm1 = Fm;
end

