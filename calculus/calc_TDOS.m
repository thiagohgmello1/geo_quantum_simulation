function TDOS = calc_TDOS(G, G_channel, H, mu, gen, iter, num, per_structs)
%cal_TDOS calculate total density of states at specified energy
    
    TDOS = zeros(iter.energy.points, 1);
    i = 1;
    for energy=iter.energy.vec
        [~, A, ~] = Green(G, G_channel, energy, H, mu, gen, iter, num, per_structs);
        TDOS(i) = 1 / (2 * pi) * trace(A);
        i = i + 1;
    end
end