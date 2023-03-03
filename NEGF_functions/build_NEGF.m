function [H, Green_r, Green_a, Green_n, A, Gamma_left, Gamma_right, Sigma_left, Sigma_right, Sigma_in_left, Sigma_in_right] = ...
    build_NEGF(G, dir_G, U, epsilon, t, energy, eta, stop_cond, fermi_left, fermi_right)
%build_NEGF build NEGF from parameters

    n_atoms = numnodes(G);
    Eye_aux = eye(n_atoms);
    H = build_H(dir_G, epsilon, t);
    [Sigma_left,Sigma_right] = build_self_energy(G, epsilon, t, energy, eta, stop_cond);
    
    Gamma_left = 1i*(Sigma_left - Sigma_left');
    Gamma_right = 1i*(Sigma_right - Sigma_right');

    Sigma_in_left = Gamma_left * fermi_left;
    Sigma_in_right = Gamma_right * fermi_right;
    Sigma_in = Sigma_in_left + Sigma_in_right;
    
    Green_r = ((energy + 1i * eta) * Eye_aux - (H + U) - Sigma_right - Sigma_left) \ Eye_aux;
    Green_n = Green_r * Sigma_in * Green_r';
    Green_a = Green_r';
    A = 1i * (Green_r - Green_r');
end