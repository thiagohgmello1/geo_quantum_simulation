function [I, V, rho, H] = calc_IV_curve(G_complete, system, channel_id, mat, iter, num, mu, gen, from_id, to_id)
%CACL_IV_CURVE calculate IV curve for specific topology

    V = linspace(-1 * abs(mu(1)), abs(mu(1)), iter.current.v_points);
    I = zeros(length(V), 1);
    count = 1;

    per_structs = def_periodic_structures(G_complete, system, mat.a, mat.epsilon, mat.t);
    G_channel = G_nodes_by_id(G_complete, channel_id);

    for volt=V
        mu = [-volt / 2, volt / 2]
        [rho, H] = non_eq_solver(G_complete, system, channel_id, mat, iter, num, mu, gen, from_id, to_id, G_channel, per_structs);
        I(count) = calc_current(G_complete, G_channel, H, from_id, to_id, mu, gen, iter, num, per_structs)
        count = count + 1;
    end
end

