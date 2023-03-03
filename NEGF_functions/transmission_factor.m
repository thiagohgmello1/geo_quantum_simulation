function transmission = transmission_factor(Gamma_1, Gamma_2, Green_r, Green_a)
%transmission_factor calculate transmission factor from contact 1 to 2
    
    transmission = trace(Gamma_1 * Green_r * Gamma_2 * Green_a);
end