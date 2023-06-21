function [sigma, SGF] = semi_analytical_method(alpha, beta, energy)
%semi_analytical_method calculate SGF considering a semi-analytical lead
%model
    imag_tol = 1e-7;
    sigma = {};
    SGF = {};

    for i=1:length(alpha)
        [K0, K1, S0, S1, V] = build_aux_matrices(alpha{i}, beta{i}, energy);
        N = length(K0);
        [C_kp, lambda, C_kpl] = solve_generalized_eig(K0, K1, N);
        [group_vel, C_kp, ~] = calc_group_velocity(K1, S0, S1, C_kp, C_kpl, lambda);
        [left_going_idx, right_going_idx] = separate_wave_vectors(group_vel, lambda, imag_tol);
        [TR, ~] = right_transfer(C_kp, lambda, right_going_idx, left_going_idx, N);
        SGF{end + 1} = -inv(K0 + K1 * TR);
        sigma{end + 1} = K1 * TR;
    end
end


function [K0, K1, S0, S1, V, values] = build_aux_matrices(alpha, beta, energy)
    H0 = alpha;
    H1 = beta;
    N = length(H0);
    S0 = eye(N);
    S1 = zeros(N);
    K0 = H0 - energy * S0;
    K1 = H1 - energy * S1;
    [K0, K1, S0, S1, V, values] = regularize_matrices(K0, K1, S0, S1);
end


function [C_kp, lambda, C_kpl] = solve_generalized_eig(K0, K1, N)
    IN = eye(N);
    ZN = zeros(N);
    A = [-K0, -K1'; IN, ZN];
    B = [K1, ZN; ZN, IN];

    [C_kp, lambda, C_kpl] = eig(A,B);
    lambda = diag(lambda);
end


function [group_vel, C_kp, C_kpl] = calc_group_velocity(K1, S0, S1, C_kp, C_kpl, lambda)
    N = length(lambda) / 2;
    group_vel = zeros(2 * N, 1);
    for i = 1:2*N
        den = (C_kpl(1:N, i)' * (S0 + S1 * lambda(i) + S1' * 1 / lambda(i)) * C_kp(1:N, i));
        group_vel(i) = 1i * C_kpl(1:N, i)' * (K1 * lambda(i) - K1' / lambda(i)) * C_kp(1:N, i) / den;
        C_kp(1:N, i) = C_kp(1:N, i) * sqrt(group_vel(i)) / lambda(i);
        C_kpl(1:N, i) = C_kpl(1:N, i) * sqrt(group_vel(i)) / (1i * lambda(i));
    end
    C_kp = C_kp(1:N, :);
    C_kpl = C_kpl(1:N, :);
end


function [left_going_idx, right_going_idx] = separate_wave_vectors(group_vel, lambda, imag_tol)
    left_going_idx = union(intersect(find(abs(abs(lambda) - 1) < imag_tol),...
        find(real(group_vel) < 0)), find(abs(lambda) > 1 + imag_tol));

    right_going_idx = union(intersect(find(abs(abs(lambda) - 1) < imag_tol),...
        find(real(group_vel) > 0)), find(abs(lambda) < 1 - imag_tol));
end


function [TR, TR_bar] = right_transfer(C_kp, lambda, in_idx, out_idx, N)
    [Q, Q_bar] = build_Q_matrices(C_kp, in_idx, out_idx);
    Q_til = inv(Q)';
    Q_bar_til = inv(Q_bar)';
    TR = zeros(N, 1);
    TR_bar = zeros(N, 1);
    lambda_aux = lambda(in_idx);
    lamda_bar_aux = lambda(out_idx);
    for i=1:N
        TR = TR + Q(:, i) * lambda_aux(i) * Q_til(:, i)';
        TR_bar = TR_bar + Q_bar(:, i) * lamda_bar_aux(i) * Q_bar_til(:, i)';
    end
end


function [Q, Q_bar] = build_Q_matrices(C_kp, in_idx, out_idx)
    Q = C_kp(:, in_idx);
    Q_bar = C_kp(:, out_idx);
end
















