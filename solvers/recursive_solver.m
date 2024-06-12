function results = recursive_solver(G_complete, system, ...
    channel_id, mat, iter, num, mu, gen, from_id, to_id, G_channel, per_structs, rho_0, model)

    delta_volt = inf;
    while delta_volt > iter.conv.delta_volt
        [rho, ~] = non_eq_solver(G_complete, system, channel_id, mat, iter, num, mu, gen, from_id, to_id, G_channel, per_structs);
        delta_rho = rho - rho_0;
        results = poisson_solver(delta_rho, G_complete, model, a);
    end
    
end