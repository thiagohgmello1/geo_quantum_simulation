function [Gamma_left, Gamma_right, Sigma_left, Sigma_right, Sigma_in_left, Sigma_in_right] = ...
    build_NEGF(G, epsilon, t, energy, eta, stop_cond, fermi_left, fermi_right)
%build_NEGF build NEGF from parameters

    [Sigma_left, Sigma_right] = build_self_energy(G, epsilon, t, energy, eta, stop_cond);
    
    Gamma_left = 1i * (Sigma_left - Sigma_left');
    Gamma_right = 1i * (Sigma_right - Sigma_right');

    Sigma_in_left = Gamma_left * fermi_left;
    Sigma_in_right = Gamma_right * fermi_right;

end