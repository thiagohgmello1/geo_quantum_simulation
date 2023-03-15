function [Green_r, Green_n, Green_a, A] = build_greens_params(G, ...
    energy, eta, H, U, Sigma_right, Sigma_left, Sigma_in_left, Sigma_in_right)
%build_greens_params create Green's matrices
    
    n_atoms = numnodes(G);
    Eye_aux = eye(n_atoms);
    Sigma_in = Sigma_in_left + Sigma_in_right;
%     Green_r = ((energy + 1i * eta) * Eye_aux - (H + U) - Sigma_right - Sigma_left) \ Eye_aux; % Retarded Green's function
    Green_r = (energy * Eye_aux - (H + U) - Sigma_right - Sigma_left) \ Eye_aux; % Retarded Green's function
    Green_a = Green_r'; % Advanced Green's function
    Green_n = Green_r * Sigma_in * Green_a; % Electron density (diagonal elements)
    
    A = 1i * (Green_r - Green_r'); % Density of states (diagonal elements)
end