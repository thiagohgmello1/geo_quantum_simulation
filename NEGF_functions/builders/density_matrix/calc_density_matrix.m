function rho = calc_density_matrix(G, system, H, U, from_id, to_id, mu, gen, iter, mat, num)
%UNTITLED Summary of this function goes here

    rho_eq = calc_rho_eq(G, H, U, system, from_id, mu, gen, iter, mat, num);
    rho_neq = calc_rho_neq(G, system, H, U, from_id, to_id, mu, gen, iter, mat, num);
    rho = rho_eq + rho_neq;
end


function rho_eq = calc_rho_eq(G, H, U, system, from_id, mu, gen, iter, mat, num)
    G_channel = G_nodes_by_id(G, 0);
    R = calc_R(G, G_channel, H, U, system, mu, gen, iter, mat, num);
    [poles, residues] = calc_poles_residues(num.rho_eq.n_poles);
    chi = mu(from_id) + gen.kB * gen.temp * poles;
    green_r = calc_green_r(G, G_channel, system, H, U, 1i * R, mu, gen, iter, mat, num);
    rho_eq = 1 / 2 * 1i * R * green_r;
    
    sum_iter = 0;
    for i=1:num.rho_eq.n_poles
        green_r = calc_green_r(G, G_channel, system, H, U, chi(i), mu, gen, iter, mat, num);
        sum_iter = sum_iter + residues(i) * green_r;
    end
    rho_eq = rho_eq - imag(2i * gen.kB * gen.temp * sum_iter);
end


function [poles, residues] = calc_poles_residues(N_poles)
    M = 2 * N_poles;
    A = diag(-1 * linspace(1, 2 * M - 1, M));
    B = 1 / 2 * (diag(ones(M - 1 ,1), 1) + diag(ones(M - 1 ,1), -1));

    [V, lambda] = eig(B, A);
    V_inv = inv(V);
    
    poles = 1i ./ diag(lambda);
    residues = 1 / 4 * (poles .^2)' .* V(1,:) .* V_inv(:,1)';
    pos = imag(poles) > 0;
    poles = poles(pos);
    [poles, idx] = sort(poles);
    residues = residues(pos)';
    residues = residues(idx);
end


function green_r = calc_green_r(G, G_channel, system, H, U, energy, mu, gen, iter, mat, num)
    fermi_levels = calc_fermi_levels(energy, mu, gen.temp, gen.kB);
    [~, Sigma] = build_contacts(G, mat, iter, energy, fermi_levels, system, num.method);
    [Green, ~] = build_greens_params(G_channel, energy , H, U, Sigma, iter.conv.eta);
    green_r = Green.green_r;
end


function rho_neq = calc_rho_neq(G, system, H, U, from_id, to_id, mu, gen, iter, mat, num)
    npg = num.rho_neq.npg;
    num_iter = iter.energy.points;
    e_min = iter.energy.start;
    e_max = iter.energy.stop;
    integ = @(energy) integrand(G, system, H, U, energy, from_id, to_id, mu, gen, iter, mat, num);
    rho_neq = (1 / (2 * pi)) * gauss_int_1d(integ, npg, num_iter, e_min, e_max);
end


function integ = integrand(G, system, H, U, energy, from_id, to_id, mu, gen, iter, mat, num)
    G_channel = G_nodes_by_id(G, 0);
    fermi_levels = calc_fermi_levels(energy, mu, gen.temp, gen.kB);
    [Gamma, Sigma] = build_contacts(G, mat, iter, energy, fermi_levels, system, num.method);
    [Green, ~] = build_greens_params(G_channel, energy , H, U, Sigma, iter.conv.eta);
    integ = Green.green_r * Gamma{to_id} * Green.green_a * (fermi_levels(to_id) - fermi_levels(from_id));
end








