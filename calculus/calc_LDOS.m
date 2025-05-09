function D = calc_LDOS(G_complete, G_channel, energy, H, mu, gen, iter, num, per_structs)
%cal_LDOS calculate local density of states at specified energy
    
    [~, A,~, ~] = Green(G_complete, G_channel, energy, H, mu, gen, iter, num, per_structs);
    D = 1 / (2 * pi) * diag(A);
end