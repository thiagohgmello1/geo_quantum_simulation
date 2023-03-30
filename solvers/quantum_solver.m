function [rho, Gamma_left, Gamma_right, Green_r, Green_n, Green_a, A, V] = ...
    quantum_solver(G, H, results, energy_range, delta_energy, mu_left, mu_right, temp, epsilon, t, eta, stop_cond, bounds)
%quantum_solver solver the quantum problem

    rho = zeros(numnodes(G));
    V = calc_V(G, results);
    U = -V;
    
    for energy = energy_range
        fermi_left = fermi_level(energy, mu_left, temp);
        fermi_right = fermi_level(energy, mu_right, temp);
    
        [Gamma_left, Gamma_right, Sigma_left, Sigma_right, Sigma_in_left, Sigma_in_right] = ...
            build_NEGF(G, epsilon, t, energy, eta, stop_cond, fermi_left, fermi_right, bounds);
        
        [Green_r, Green_n, Green_a, A] = build_greens_params(G, ...
            energy, eta, H, U, Sigma_right, Sigma_left, Sigma_in_left, Sigma_in_right);
        rho = rho + delta_energy * Green_n / (2 * pi);
    end
end