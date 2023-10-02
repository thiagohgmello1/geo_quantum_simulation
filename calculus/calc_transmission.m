function transmission = calc_transmission(G, G_channel, H, mu, gen, iter, num, from_id, to_id, per_structs)
%transmission_factor calculate transmission factor from contact 1 to 2
    
    transmission = zeros(iter.energy.points, 1);
    i = 1;
    for energy=iter.energy.vec
        [green, ~, Gamma, ~] = Green(G, G_channel, energy, H, mu, gen, iter, num, per_structs);
        transmission(i) = trace(Gamma{from_id} * green.green_r * Gamma{to_id} * green.green_a);
        i = i + 1;
    end
end