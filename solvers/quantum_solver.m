function [rho, Gamma, Sigma, Green, A, V] = ...
    quantum_solver(G, H, results, energy_range, delta_energy, mu, temp, ...
                   epsilon, t, eta, stop_cond, a, system, kB, Vol, method)
%quantum_solver solve the quantum problem
    
    G_channel = subgraph(G, table2array(G.Nodes(G.Nodes.contact_id == 0, 1)));
    rho = zeros(numnodes(G_channel));
    V = calc_V(G_channel, results);
    U = -V;
    
    for energy=energy_range
        fermi_levels = calc_fermi_levels(energy, mu, temp, kB);
    
        [Gamma, Sigma] = build_contacts(G, epsilon, t, energy, eta, stop_cond, fermi_levels, a, system, method);
        [Green, A] = build_greens_params(G_channel, energy , H, U, Sigma, eta);
        rho = rho + delta_energy * Green.green_n;
    end
    rho = rho / (2 * pi * Vol);
end


function fermi_levels = calc_fermi_levels(energy, mu, temperature, kB)
    fermi_levels = zeros(length(mu), 1);
    for i=1:length(mu)
        fermi_levels(i) = fermi_level(energy, mu(i), temperature, kB);
    end
end