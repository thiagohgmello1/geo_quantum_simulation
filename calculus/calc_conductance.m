function G = calc_conductance(G_complete, G_channel, H, mu, gen, iter, num, per_structs, from_id, to_id)
    %calc_conductance calculate region conductance (2 is due to the 
    % electron spin degeneracy)
    
    T = calc_transmission(G_complete, G_channel, H, mu, gen, iter, num, from_id, to_id, per_structs);
    G = (2 * gen.q^2 / gen.h) .* T;
end