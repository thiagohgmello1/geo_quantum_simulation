function rho = calc_density_matrix(G, G_channel, system, H, mu, gen, iter, mat, num , from_id, to_id)
%UNTITLED Summary of this function goes here

    rho_eq_1 = calc_rho_eq(G, G_channel, H, system, from_id, mu, gen, iter, mat, num);
%     rho_eq_2 = calc_rho_eq(G, G_channel, H, U, system, to_id, mu, gen, iter, mat, num);

    rho_neq_1 = calc_rho_neq(G, G_channel, system, H, from_id, to_id, mu, gen, iter, mat, num);
%     rho_neq_2 = calc_rho_neq(G, G_channel, system, H, U, to_id, from_id, mu, gen, iter, mat, num);
%     weight_rho = rho_neq_to ^ 2 / (rho_neq_to ^ 2 + rho_neq_from ^ 2);
%     rho = 0.5 * (rho_eq_1 + rho_neq_1) + 0.5 * (rho_eq_2 + rho_neq_2);
    rho = rho_eq_1 + rho_neq_1;
end


function rho_eq = calc_rho_eq(G, G_channel, H, system, from_id, mu, gen, iter, mat, num)
    R = calc_R(G, G_channel, H, system, mu, gen, iter, mat, num);
    [poles, residues] = calc_poles_residues(num.rho_eq.n_poles);
    chi = mu(from_id) + gen.kB * gen.temp * poles;
    green_r = calc_green_r(G, G_channel, system, H, 1i * R, mu, gen, iter, mat, num);
    rho_eq = 1 / 2 * 1i * R * green_r;
    
    sum_iter = 0;
    for i=1:num.rho_eq.n_poles
        green_r = calc_green_r(G, G_channel, system, H, chi(i), mu, gen, iter, mat, num);
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


function green_r = calc_green_r(G, G_channel, system, H, energy, mu, gen, iter, mat, num)
    [green, ~] = Green(G, G_channel, system, energy, H, mu, gen, iter, mat, num);
    green_r = green.green_r;
end


function rho_neq = calc_rho_neq(G, G_channel, system, H, from_id, to_id, mu, gen, iter, mat, num)
    npg = num.rho_neq.npg;
    num_iter = iter.energy.points;
    e_min = iter.energy.start;
    e_max = iter.energy.stop;
    integ = @(energy) integrand(energy, G, G_channel, system, H, from_id, to_id, mu, gen, iter, mat, num);
    rho_neq = (1 / (2 * pi)) * gauss_int_1d(integ, npg, num_iter, e_min, e_max);
end


function integ = integrand(energy, G, G_channel, system, H, from_id, to_id, mu, gen, iter, mat, num)
    fermi_levels = calc_fermi_levels(energy, mu, gen.temp, gen.kB);
    [green, ~, Gamma, ~] = Green(G, G_channel, system, energy, H, mu, gen, iter, mat, num);
    integ = green.green_r * Gamma{to_id} * green.green_a * (fermi_levels(to_id) - fermi_levels(from_id));
end








