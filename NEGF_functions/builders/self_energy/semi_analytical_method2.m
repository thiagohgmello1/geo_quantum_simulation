function sigma = semi_analytical_method2(alpha, beta, energy)
%semi_analytical_method2 
    imag_tol = 1e-7;
    sigma = {};
    for i_lead=1:length(alpha)
        [K0, K1, S0, S1] = build_aux_matrices(alpha{i_lead}, beta{i_lead}, energy);
        N = length(K0);
        [eig_vec_right, eig_values, eig_vec_left] = solve_generalized_eig(K0, K1, N);
%         kn = calc_wave_vector(eig_values);
        [eig_vec_right, eig_vec_left, group_vel] = calc_group_vel(K1, S0, S1, eig_vec_right, eig_vec_left, eig_values, N);
        [right_idx, left_idx] = separate_vectors(group_vel, eig_values, imag_tol);

        Q = eig_vec_right(1:N, right_idx);
        Q_bar = eig_vec_right(1:N, left_idx);
        dual_Q = dual_matrices(right_idx, eig_vec_right, N);
        dual_Q_bar = dual_matrices(left_idx, eig_vec_right, N);

        t_matrix = transfer_matrix(Q, Q_bar, eig_values, N);
        t_matrix_bar = transfer_matrix(dual_Q, dual_Q_bar, 1 / eig_values, N);
%         V = V_matrix(K1, t_matrix, t_matrix_bar);
%         C_kp = treat_degenerancy_subspace(K1, out_idx, out_open, in_idx, in_open, kn, eig_vec_right, eig_values, deg_tol, N);
%         [V, inv_sigma] = build_green(in_idx, out_idx, eig_values, eig_vec_right, K0, K1, N);
        sigma{end + 1} = K1 * t_matrix;
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
    [K0, K1, S0, S1, ~] = regularize_matrices(K0, K1, S0, S1);
end


function [eig_vec_right, eig_values, eig_vec_left] = solve_generalized_eig(K0, K1, N)
    IN = eye(N);
    ZN = zeros(N);
    A = [-K0, -K1'; IN, ZN];
    B = [K1, ZN; ZN, IN];

    [eig_vec_right, eig_values, eig_vec_left] = eig(A,B);
    eig_values = diag(eig_values);
end


function kn = calc_wave_vector(lambda)
    kn = -1i * log(lambda);
end


function [eig_vec_right, eig_vec_left, group_vel] = calc_group_vel(K1, S0, S1, eig_vec_right, eig_vec_left, eig_values, N)
    group_vel = zeros(2 * N, 1);
    for i = 1:2*N
        normalizer = eig_vec_left(1:N, i)' * (S0 + S1 * eig_values(i) + S1' * ...
            1 / eig_values(i)) * eig_vec_right(1:N, i);

        eig_vec_left(1:N, i) = eig_vec_left(1:N, i) / sqrt(normalizer)';
        eig_vec_right(1:N, i) = eig_vec_right(1:N, i) / sqrt(normalizer);

        group_vel(i) = 1i * eig_vec_left(1:N, i)' * (K1 * eig_values(i) - ...
            K1' / eig_values(i)) * eig_vec_right(1:N, i);
    end
end


function [right_going_idx, left_going_idx] = separate_vectors(group_vel, eig_values, imag_tol)
    
    right_going_idx = union(intersect(find(abs(abs(eig_values) - 1) < imag_tol), find(real(group_vel) > 0)), ...
        find(abs(eig_values) < 1 - imag_tol));
    
    left_going_idx = union(intersect(find(abs(abs(eig_values) - 1) < imag_tol), find(real(group_vel) < 0)), ...
        find(abs(eig_values) > 1 + imag_tol));
end


function dual_going_vecs = dual_matrices(going_states, going_vecs, N)
    vecs = going_vecs(1:N, going_states);
    dual_going_vecs = inv(vecs)';
end


function t_matrix = transfer_matrix(C_n, dual_C_n, eig_values, N)
    t_matrix = zeros(N);
    for i=1:N
        t_matrix = t_matrix + C_n(:, i) * eig_values(i) * dual_C_n(:, i)';
    end
end


function V = V_matrix(K1, t_matrix, t_matrix_bar)
    V = K1' * (inv(t_matrix) - t_matrix_bar);
end














