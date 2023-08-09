function I = calc_current(G, G_channel, system, H, from_id, to_id, mu, gen, iter, mat, num)
%calc_current calculate current in terminal
    
    npg = num.rho_neq.npg;
    num_iter = iter.energy.points;
    e_min = iter.energy.start;
    e_max = iter.energy.stop;
    integ = @(energy) integrand(energy, G, G_channel, system, H, from_id, to_id, mu, gen, iter, mat, num);
    I = gen.q / gen.h * gauss_int_1d(integ, npg, num_iter, e_min, e_max);
end


function integ = integrand(energy, G, G_channel, system, H, from_id, to_id, mu, gen, iter, mat, num)
    fermi_levels = calc_fermi_levels(energy, mu, gen.temp, gen.kB);
    [green, ~, Gamma, ~] = Green(G, G_channel, system, energy, H, mu, gen, iter, mat, num);
    T = trace(Gamma{from_id} * green.green_r * Gamma{to_id} * green.green_a);
    integ = T * (fermi_levels(to_id) - fermi_levels(from_id));
end