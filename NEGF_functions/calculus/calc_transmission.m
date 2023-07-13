function transmission = calc_transmission(Gamma, Green, from_id, to_id)
%transmission_factor calculate transmission factor from contact 1 to 2
    
    transmission = trace(Gamma{from_id} * Green.green_r * Gamma{to_id} * Green.green_a);
end