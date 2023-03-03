function I = calc_current(Sigma_in, A, Gamma, Green_n)
%calc_current calculate current in terminal
    
    q = 1.60217663 * 1e-19; % electron charge
    h = 6.62607015 * 1e-34; % Planck constant
    I = q / h * trace(Sigma_in * A - Gamma * Green_n);
end