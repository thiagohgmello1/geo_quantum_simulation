function rho = quantum_solver(G, H, mat, iter, gen, num, results, mu, system)
%quantum_solver solve the quantum problem
    
    G_channel = G_nodes_by_id(G, 0);
    if isequal(class(results), 'pde.StationaryResults')
        V = calc_V(G_channel, results);
    else
        V = zeros(numnodes(G_channel));
    end
    U = sparse(V);

    rho = calc_density_matrix(G, system, H, U, 1, 2, mu, gen, iter, mat, num);
end








