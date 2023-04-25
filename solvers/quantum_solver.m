function [rho, Gamma, Sigma, Sigma_in, Green_r, Green_n, Green_a, A, V] = ...
    quantum_solver(G, H, results, energy_range, delta_energy, mu, temp, epsilon, t, eta, stop_cond, a, system)
%quantum_solver solve the quantum problem
    
    G_channel = subgraph(G, table2array(G.Nodes(G.Nodes.contact_id == 0, 1)));
    rho = zeros(numnodes(G_channel));
    V = calc_V(G_channel, results);
    U = -V;
    
    for energy=energy_range
        fermi_levels = calc_fermi_levels(energy, mu, temp);
    
        [Gamma, Sigma, Sigma_in] = build_contacts(G, epsilon, t, energy, eta, stop_cond, fermi_levels, a, system);
        [Green_r, Green_n, Green_a, A] = build_greens_params(G_channel, energy , H, U, Sigma, Sigma_in);
        rho = rho + delta_energy * Green_n / (2 * pi);
    end
end


function fermi_levels = calc_fermi_levels(energy, mu, temperature)
    fermi_levels = zeros(length(mu), 1);
    for i=1:length(mu)
        fermi_levels(i) = fermi_level(energy, mu(i), temperature);
    end
end