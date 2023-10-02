function [rho_in, H] = non_eq_solver(G_complete, system, channel_id,...
    mat, iter, num, mu, gen, from_id, to_id, G_channel, per_structs)
%NON_EQ_SOLVER solve NEGF and Poisson equations self-consistently

    H0 = build_H(G_complete, mat, channel_id);
    
    rho_in = sparse(zeros(numnodes(G_channel)));
    U_gate = sparse(eye(numnodes(G_channel))) * gen.V_gate;
    
    counter = 0;
    recurrent_counter = 0;
    e = iter.conv.e;
    rho_in1 = 0;
    Fm1 = 0;
    Qm1 = 0;

    while recurrent_counter < iter.conv.recurrent_rho && counter < iter.conv.max_iter
        coulomb_energy = -mat.t * mat.coulomb * sparse(diag(diag(rho_in)));
        H = H0 - U_gate + coulomb_energy;

        rho_out = calc_density_matrix(G_complete, G_channel, system, H, mu, gen, iter, mat, num, from_id, to_id, per_structs);
        [rho_diff, rho_in1, Fm, Fm1, Qm, Qm1] = conv_acceleration(rho_in, rho_in1, rho_out, Fm1, Qm1, e, counter);

        if abs(rho_diff) < iter.conv.rho_tol
            recurrent_counter = recurrent_counter + 1;
        else
            recurrent_counter = 0;
        end

        rho_in = rho_in - e * Fm - Qm * Fm;
        counter = counter + 1;
        disp([rho_diff, counter]);
    end

end


function [rho_diff, rho_in1, Fm, Fm1, Qm, Qm1] = conv_acceleration(rho_in, rho_in1, rho_out, Fm1, Qm1, e, counter)
    Fm = diag(rho_out - rho_in);

    if counter > 0
        delta_Fm = Fm - Fm1;
        if delta_Fm == 0
            VmT = zeros(size(delta_Fm'));
        else
            VmT = delta_Fm' / (delta_Fm' * delta_Fm);
        end
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

