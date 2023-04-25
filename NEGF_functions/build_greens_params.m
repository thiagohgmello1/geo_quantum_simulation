function [Green_r, Green_n, Green_a, A] = build_greens_params(G, energy, H, U, Sigma, Sigma_in)
%build_greens_params create Green's matrices
    
    n_atoms = numnodes(G);
    I = eye(n_atoms);
    Sigma_in = plus(Sigma_in{:});
    Sigma = plus(Sigma{:});
%     Green_r = ((energy + 1i * eta) * I - (H + U) - Sigma) \ I; % Retarded Green's function
    Green_r = (energy * I - (H + U) - Sigma) \ I; % Retarded Green's function
    Green_a = Green_r';
    Green_n = Green_r * Sigma_in * Green_a; % Electron density (diagonal elements)
    
    A = 1i * (Green_r - Green_r'); % Density of states (diagonal elements)
end