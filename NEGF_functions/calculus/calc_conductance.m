function G = calc_conductance(gen, Gamma, Green, from_id, to_id)
    %calc_conductance calculate region conductance (2 is due to the 
    % electron spin degeneracy)
    
    T = calc_transmission(Gamma, Green, from_id, to_id);
    G = (2 * gen.q^2 / gen.h) * T;
end