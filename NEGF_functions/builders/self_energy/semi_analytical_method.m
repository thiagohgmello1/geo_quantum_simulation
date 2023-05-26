function [sigma, SGF, V] = semi_analytical_method(alpha, beta, energy)
%semi_analytical_method calculate SGF considering a semi-analytical lead
%model
    imag_tol = 1e-7;
    deg_tol = 1e-8;
    sigma = {};
    SGF = {};
    coupling = {};

    for i=1:length(alpha)
        [K0, K1, S0, S1] = build_aux_matrices(alpha{i}, beta{i}, energy);
        N = length(K0);
        [C_kp, lambda] = solve_generalized_eig(K0, K1, N);
        kp = calc_wave_vector(lambda);
        [group_vel, C_kp] = calc_group_velocity(K1, S0, S1, C_kp, lambda);
        [out_idx, out_going, in_idx, in_going] = separate_wave_vectors(group_vel, lambda, imag_tol);
        C_kp = treat_degenerancy_subspace(K1, out_idx, out_going, in_idx, in_going, kp, C_kp, lambda, deg_tol, N);
        [self_energy, G_surface, V] = build_parameters(in_idx, out_idx, lambda, C_kp, K0, K1, N);
        coupling{end + 1} = V;
        SGF{end + 1} = G_surface;
        sigma{end + 1} = self_energy;
    end
end


function [K0, K1, S0, S1] = build_aux_matrices(alpha, beta, energy)
    H0 = alpha;
    H1 = beta;
    N = length(H0);
    S0 = eye(N);
    S1 = zeros(N);
    K0 = H0 - energy * S0;
    K1 = H1 - energy * S1;
    [K0, K1, S0, S1] = regularize_matrices(K0, K1, S0, S1);
end


function [C_kp, lambda] = solve_generalized_eig(K0, K1, N)
    IN = eye(N);
    ZN = zeros(N);
    A = [-K0, -K1'; IN, ZN];
    B = [K1, ZN; ZN, IN];

    [C_kp, lambda, C_kpl] = eig(A,B);
    lambda = diag(lambda);
end


function kp = calc_wave_vector(lambda)
    kp = log(lambda) / (1i * pi);
end


function [group_vel, C_kp] = calc_group_velocity(K1, S0, S1, C_kp, lambda)
    N = length(lambda) / 2;
    group_vel = zeros(2 * N, 1);
    for i = 1:2*N
        normalizer = C_kp(1:N, i)' * (S0 + S1 * lambda(i) + S1' * 1 / lambda(i)) * C_kp(1:N, i);
        C_kp(1:N, i) = C_kp(1:N, i) / lambda(i);
        C_kp_normal = C_kp(1:N, i)/sqrt(normalizer);
        group_vel(i) = 1i * C_kp_normal' * (K1 * lambda(i) - K1' / lambda(i)) * C_kp_normal;
    end
end


function [out_idx, out_going, in_idx, in_going] = separate_wave_vectors(group_vel, lambda, imag_tol)
    out_idx = union(intersect(find(abs(abs(lambda) - 1) < imag_tol),...
        find(real(group_vel) < 0)), find(abs(lambda) > 1 + imag_tol));
    out_going = intersect(find(abs(abs(lambda(out_idx)) - 1) < imag_tol),...
        find(real(group_vel(out_idx)) < 0));

    in_idx = union(intersect(find(abs(abs(lambda) - 1) < imag_tol),...
        find(real(group_vel) > 0)), find(abs(lambda) < 1 - imag_tol));
    in_going = intersect(find(abs(abs(lambda(in_idx)) - 1) < imag_tol),...
        find(real(group_vel(in_idx)) > 0));
end


function C_kp = treat_degenerancy_subspace(K1, out_idx, out_open, in_idx, in_open, kp, C_kp, lambda, deg_tol, N)
    function C_kp = treat_eig_vector(K1, index, kp, deg_tol, lambda, C_kp, N)
        while ~isempty(index)
            i = find(abs(kp - kp(index(1))) < deg_tol);
            if length(i) > 1
                Curr_red = 1i * C_kp(1:N, i)' * (K1 * lambda(i(1)) - K1' / lambda(i(1))) * C_kp(1:N, i);
                [ROT, ~] = eig(Curr_red);
                C_kp(:, i) = C_kp(:, i) * ROT;
            end
            index = setdiff(index, i);
        end
    end

    index = in_idx(in_open);
    C_kp = treat_eig_vector(K1, index, kp, deg_tol, lambda, C_kp, N);
    
    index = out_idx(out_open);
    C_kp = treat_eig_vector(K1, index, kp, deg_tol, lambda, C_kp, N);

    for idx=1:2*N
        if C_kp(1, idx) ~= 0
            C_kp(1:N, idx) = C_kp(1:N, idx) * abs(C_kp(1, idx)) / C_kp(1, idx);
        end
    end
end


function [self_energy, G_surface, V] = build_parameters(in_idx, out_idx, lambda, C_kp, K0, K1, N)
    Q = C_kp(1:N, in_idx);
    Q_bar = C_kp(1:N, out_idx);
    D = (Q \ eye(length(Q)))';
    D_bar = (Q_bar \ eye(length(Q_bar)))';
    

    transfer = zeros(N);
    transfer_bar = zeros(N);

%     transfer = Q * (diag(lambda(in_idx))) * D;
%     transfer_bar = Q_bar * (diag(1 ./ lambda(out_idx))) * D_bar;
    
    for i=1:N
        transfer = transfer + Q(:, i) * (diag(lambda(in_idx(i)))) * D(:, i)';
        transfer_bar = transfer_bar + Q_bar(:, i) * (diag(1 ./ lambda(out_idx(i)))) * D_bar(:, i)';
    end

    V = K1' * (transfer \ eye(length(transfer)) - transfer_bar);
    self_energy = K1 * transfer;
    G_surface = -inv(K0 + self_energy);
end














