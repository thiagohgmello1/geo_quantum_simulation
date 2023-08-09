function G = calc_conductance(G, G_channel, system, H, mu, gen, iter, mat, num, from_id, to_id)
    %calc_conductance calculate region conductance (2 is due to the 
    % electron spin degeneracy)
    
    T = calc_transmission(G, G_channel, system, H, mu, gen, iter, mat, num, from_id, to_id);
    G = (2 * gen.q^2 / gen.h) .* T;
end