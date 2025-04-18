function [I, V, rho, H] = calc_IV_curve(G_complete, system, channel_id, mat, iter, num, mu, gen, model)
%CACL_IV_CURVE calculate IV curve for specific topology
    
    V = linspace(gen.chemical_pot(1) - mu(1), gen.chemical_pot(2) - mu(2), iter.current.v_points);
    I = zeros(length(V), 1);
    count = 1;

    per_structs = def_periodic_structures(G_complete, system, mat.a, mat.epsilon, mat.t);
    G_channel = G_nodes_by_id(G_complete, channel_id);
    rho_0 = sparse(zeros(numnodes(G_channel)));
    
    for volt=V
        mu = [-volt / 2, volt / 2]
        [rho, H] = recursive_solver(G_complete, system, channel_id, mat, iter, num, mu, gen, G_channel, per_structs, rho_0, model);
        I(count) = calc_current(G_complete, G_channel, H, mu, gen, iter, num, per_structs)
        count = count + 1;
    end
 end

