function [rho, Gamma, Sigma, Green, A, V] = ...
    quantum_solver(G, H, mat, iter, gen, results, mu, system, Vol, method)
%quantum_solver solve the quantum problem
    
    G_channel = subgraph(G, table2array(G.Nodes(G.Nodes.contact_id == 0, 1)));
    rho = zeros(numnodes(G_channel));
    V = calc_V(G_channel, results);
    U = -V;

    % TEST
%     U = zeros(length(V));
%     count = 1;
    
    for energy=iter.energy.vec
        fermi_levels = calc_fermi_levels(energy, mu, gen.temp, gen.kB);
    
        [Gamma, Sigma] = build_contacts(G, mat.epsilon, mat.t, energy, ...
            iter.conv.eta, iter.conv.self_e_stop, fermi_levels, mat.a, system, method);
        [Green, A] = build_greens_params(G_channel, energy , H, U, Sigma, iter.conv.eta);
        rho = rho + iter.energy.delta * Green.green_n;

        % TEST
%         t_test(count) = calc_transmission(Gamma, Green, 1, 2);
%         aux_test = calc_LDOS(A);
%         D_test(count) = aux_test(40);
%         count = count + 1;
    end
    rho = rho / (2 * pi);
end


function fermi_levels = calc_fermi_levels(energy, mu, temperature, kB)
    fermi_levels = zeros(length(mu), 1);
    for i=1:length(mu)
        fermi_levels(i) = fermi_level(energy, mu(i), temperature, kB);
    end
end