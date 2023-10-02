function sigma = build_self_energy(G, iter, energy, method, per_structs)
%build_self_energy build self energy matrices for contacts
    
    alpha = per_structs.alpha;
    beta = per_structs.beta;
    tau = per_structs.tau;

    if method == 1
        [sigma, ~] = recurrent_method2(G, alpha, beta, tau, energy, iter.conv.eta, iter.conv.self_e_stop);
    else
        [sigma, ~] = recurrent_method(G, alpha, beta, tau, energy, iter.conv.eta, iter.conv.self_e_stop);
    end
end










