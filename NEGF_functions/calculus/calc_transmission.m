function transmission = calc_transmission(G, G_channel, system, H, U, mu, gen, iter, mat, num, from_id, to_id)
%transmission_factor calculate transmission factor from contact 1 to 2
    
    transmission = zeros(iter.energy.points, 1);
    i = 1;
    for energy=iter.energy.vec
        [green, ~, Gamma, ~] = Green(G, G_channel, system, energy, H, U, mu, gen, iter, mat, num);
        transmission(i) = trace(Gamma{from_id} * green.green_r * Gamma{to_id} * green.green_a);
        i = i + 1;
    end
end