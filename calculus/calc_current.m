function I = calc_current(G, G_channel, H, mu, gen, iter, num, per_structs)
%calc_current calculate current in terminal
    
    npg = num.rho_neq.npg;
    num_iter = iter.energy.points;
    e_min = iter.energy.start;
    e_max = iter.energy.stop;
    integ = @(energy) integrand(energy, G, G_channel, H, mu, gen, iter, num, per_structs);
    I = gen.q / gen.h * gauss_int_1d(integ, npg, num_iter, e_min, e_max);
end


function integ = integrand(energy, G, G_channel, H, mu, gen, iter, num, per_structs)
    fermi_levels = calc_fermi_levels(energy, mu, gen.temp, gen.kB);
    [green, ~, Gamma, ~] = Green(G, G_channel, energy, H, mu, gen, iter, num, per_structs);
    T = trace(Gamma{gen.from_id} * green.green_r * Gamma{gen.to_id} * green.green_a);
    integ = T * (fermi_levels(gen.to_id) - fermi_levels(gen.from_id));
end