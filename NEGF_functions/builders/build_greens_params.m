function [Green, A] = build_greens_params(G, energy, H, U, Sigma, eta)
%build_greens_params create Green's matrices
    
    Green = struct();
    n_atoms = numnodes(G);
    I = eye(n_atoms);
    sigma_in = plus(Sigma.sigma_in{:});
    sigma = plus(Sigma.sigma{:});
    Green.green_r = ((energy + 1i * eta) * I - (H + U) - sigma) \ I;       % Alternative retarded Green's function
%     Green.green_r = (energy * I - (H + U) - sigma) \ I;                    % Retarded Green's function
    Green.green_a = Green.green_r';
    Green.green_n = Green.green_r * sigma_in * Green.green_a;              % Electron density (diagonal elements)
    A = 1i * (Green.green_r - Green.green_r');                             % Local density of states (diagonal elements)
end