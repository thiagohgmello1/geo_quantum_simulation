function [Green, A] = build_greens_params(G, energy, H_total, Sigma, eta)
%build_greens_params create Green's matrices
    
    Green = struct();
    n_atoms = numnodes(G);
    I = sparse(eye(n_atoms));
    sigma_in = plus(Sigma.sigma_in{:});
    sigma = plus(Sigma.sigma{:});
    Green.green_r = full(((energy + 1i * eta) * I - H_total - sigma) \ I); % Alternative retarded Green's function
    Green.green_a = Green.green_r';
%     Green.green_a = full(((energy - 1i * eta) * I - H_total - sigma) \ I);
    Green.green_n = Green.green_r * sigma_in * Green.green_a;              % Electron density (diagonal elements)
    A = 1i * (Green.green_r - Green.green_a);                              % Local density of states (diagonal elements)
end