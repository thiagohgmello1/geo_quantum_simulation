function [sigma, SGF] = semi_analytical_method(alpha, beta, energy)
%semi_analytical_method calculate SGF considering a semi-analytical lead
%model
    imag_tol = 1e-7;
    sigma = {};
    SGF = {};
    
    % AJUSTAR SINAL DO VALOR COMPLEXO (ESTÁ TROCADO)
    for i=1:length(alpha)
        [K, S, Fn, len] = build_aux_matrices(alpha{i}, beta{i}, energy);
        [Phi, lambda] = solve_generalized_eig(K);
        [group_vel, Phi] = calc_group_velocity(K, S, Phi, lambda);
        [left_going_idx, right_going_idx] = separate_wave_vectors(group_vel, lambda, imag_tol);
        TR = build_TR(Phi, lambda, right_going_idx, left_going_idx, len, Fn);
        sigma{end + 1} = build_Sigma(Phi, lambda, right_going_idx, left_going_idx, len, Fn, K);
        SGF{end + 1} = -inv(K.K0 + sigma{end});
    end
end


function [K, S, Fn, len] = build_aux_matrices(alpha, beta, energy)
    H0 = alpha;
    H1 = beta;
    N = length(H0);
    S0 = eye(N);
    S1 = zeros(N);
    K0 = H0 - energy * S0;
    K1 = H1 - energy * S1;
    [K, S, Fn, len] = regularize_matrices(K0, K1, S0, S1);
end


function [Phi, lambda] = solve_generalized_eig(K)
    N = length(K.K0_eff);
    IN = eye(N);
    ZN = zeros(N);
    A = [-K.K0_eff, -K.Km1_eff; IN, ZN];
    B = [K.K1_eff, ZN; ZN, IN];

    [Phi_R, lambda, Phi_L] = eig(A, B);
    Phi = struct();
    Phi.R = Phi_R;
    Phi.L = Phi_L;
    lambda = diag(lambda);
end


function [group_vel, Phi] = calc_group_velocity(K, S, Phi, lambda)
    N = length(lambda) / 2;
    group_vel = zeros(2 * N, 1);
    Phi_R = Phi.R(1:N, :);
    Phi_L = Phi.L(1:N, :);
    for i = 1:2*N
        den = (Phi_L(:, i)' * (S.S0_eff + S.S1_eff * lambda(i) + S.Sm1_eff * 1 / lambda(i)) * Phi_R(:, i));
        group_vel(i) = 1i * Phi_L(:, i)' * (K.K1_eff * lambda(i) - K.Km1_eff / lambda(i)) * Phi_R(:, i) / den;
        Phi_R(:, i) = Phi_R(:, i) * sqrt(group_vel(i)) / lambda(i);
        Phi_L(:, i) = Phi_L(:, i) * sqrt(group_vel(i)) / (1i * lambda(i));
    end
    Phi = struct();
    Phi.R = Phi_R;
    Phi.L = Phi_L;
end


function [left_going_idx, right_going_idx] = separate_wave_vectors(group_vel, lambda, imag_tol)
    left_going_idx = union(intersect(find(abs(abs(lambda) - 1) < imag_tol),...
        find(real(group_vel) < 0)), find(abs(lambda) > 1 + imag_tol));

    right_going_idx = union(intersect(find(abs(abs(lambda) - 1) < imag_tol),...
        find(real(group_vel) > 0)), find(abs(lambda) < 1 - imag_tol));
end


function TR = build_TR(Phi, lambda, in_idx, out_idx, len, Fn)
    M = len.N - len.N_eff;
    ZN_sup = zeros(len.N_eff, M);
    ZN_inf = zeros(M, M);

    [Q, ~] = build_Q_matrices(Phi, in_idx, out_idx);
    Q_til = inv(Q)';
    TR = zeros(len.N);
    lambda_aux = lambda(in_idx);
    for i=1:len.N_eff
        F = Fn.minus_D_inv * (Fn.Km1u * 1 / lambda_aux(i) + Fn.C);
        aux_sup = Q(:, i) * lambda_aux(i) * Q_til(:, i)';
        aux_inf = F * Q(:, i) * lambda_aux(i) * Q_til(:, i)';
        TR = TR + [aux_sup, ZN_sup; aux_inf, ZN_inf];
    end
end


function Sigma = build_Sigma(Phi, lambda, in_idx, out_idx, len, Fn, K)
    M = len.N - len.N_eff;
    ZN_sup = zeros(len.N_eff, M);
    ZN_inf1 = zeros(M, len.N_eff);
    ZN_inf2 = zeros(M, M);
    

    [Q, ~] = build_Q_matrices(Phi, in_idx, out_idx);
    Q_til = inv(Q)';
    Sigma_eff = zeros(len.N_eff);
    lambda_aux = lambda(in_idx);
    for i=1:len.N_eff
        Sigma_eff = Sigma_eff + lambda_aux(i) * Q(:, i) * Q_til(:, i)';
    end
    Sigma_eff = K.K1_eff * Sigma_eff;
    Sigma = [Sigma_eff - Fn.Km1u' * (-Fn.minus_D_inv) * Fn.Km1u, ZN_sup; ZN_inf1, ZN_inf2];
    Sigma = Fn.U * Sigma * Fn.U';
end


function [Q, Q_bar] = build_Q_matrices(Phi, in_idx, out_idx)
    Q = Phi.R(:, in_idx);
    Q_bar = Phi.R(:, out_idx);
end
















