function I = calc_current(Sigma_in, A, Gamma, Green_n, q, h)
%calc_current calculate current in terminal

    I = q / h * trace(Sigma_in * A - Gamma * Green_n);
end