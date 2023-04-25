function transmission = calc_transmission(Gamma, Green_r, Green_a, from_id, to_id)
%transmission_factor calculate transmission factor from contact 1 to 2
    
    transmission = trace(Gamma{from_id} * Green_r * Gamma{to_id} * Green_a);
end