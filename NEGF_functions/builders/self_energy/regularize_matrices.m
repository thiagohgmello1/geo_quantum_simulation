function [K0, K1, S0, S1, A_aux, B_aux] = regularize_matrices(K0, K1, S0, S1, varargin)
%regularize_matrices Regularize matrices based on K0 singularity

    defaultDetTol = 1e-12;
    defaultDeltaSVD = 1e-9;

    p = inputParser;
    addRequired(p,'K0');
    addRequired(p,'K1');
    addRequired(p,'S0');
    addRequired(p,'S1');
    addOptional(p, 'det_tol', defaultDetTol);
    addOptional(p, 'delta_SVD', defaultDeltaSVD);
    parse(p, K0, K1, S0, S1, varargin{:});
    det_tol = p.Results.det_tol;
    delta_SVD = p.Results.delta_SVD;
    
    N = length(K1);
    
    if rank(K1) ~= N || abs(det(K1)) < det_tol
        [K1, U, S, V] = calc_svd(K1, N, delta_SVD);
        [A_aux, B_aux, K0, K1, S0, S1] = reduce_matrix_size(K0, K1, S0, S1, S, V, delta_SVD, N);
        K1 = regularize_small_elements(K1, delta_SVD, N);
        K1 = add_small_imaginary(K1, delta_SVD);
    end
end


function [K1, U, S, V] = calc_svd(K1, N, delta_SVD)
    try
        [U, S, V] = svd(K1);
        S = diag(S);
    catch
        max_perturbation = delta_SVD * max(max(abs(K1)));
        K1 = K1 + max_perturbation * (-1 + 2 * rand(N));
        [~, S, V] = svd(K1);
        S = diag(S);
    end
end


function [K0_eff, K1_eff, K_1_eff] = reduce_matrix_size2(K0, U, S, V, delta_SVD, N)
    min_to_keep = delta_SVD * max(S);
    keeped_sing_values = find(S > min_to_keep);
    decimated_sing_values = setdiff(1:N, keeped_sing_values);
    M = length(decimated_sing_values);
    N_eff = length(keeped_sing_values);

    S_SVD = S;
    S_SVD(decimated_sing_values) = 0;

    K1_SVD = U * diag(S_SVD) * V';
    K1_trans = U' * K1_SVD * U;
    K_1_trans = U' * K1_SVD' * U;
    K0_trans = U' * K0 * U;
    
    K_1u = K_1_trans(decimated_sing_values, keeped_sing_values);
    K_1c = K_1_trans(keeped_sing_values, keeped_sing_values);
    K1c = K1_trans(keeped_sing_values, keeped_sing_values);
    K1u = K1_trans(keeped_sing_values, decimated_sing_values);
    A = K0_trans(keeped_sing_values, keeped_sing_values);
    B = K0_trans(keeped_sing_values, decimated_sing_values);
    C = K0_trans(decimated_sing_values, keeped_sing_values);
    D = K0_trans(decimated_sing_values, decimated_sing_values);

    K1_eff = K1c - K1u / D * C;
    K_1_eff = K_1c - B / D * K_1u;
    K0_eff = A - B / D * C - K1u / D * K_1u;
end


function [A_aux, B_aux, K0, K1, S0, S1] = reduce_matrix_size(K0, K1, S0, S1, S, V, delta_SVD, N)
    B_aux = K0;
    A_aux = K1;
    if rank(K1) ~= N
        min_eig = delta_SVD * max(S);
        keeped_eigs = find(S > min_eig);
        decimated_eigs = setdiff(1:N, keeped_eigs);
        K0_trans = V' * K0 * V;
        K1_trans = V' * K1 * V;
        K1_pre = V' * K1;

        K0_M = K0_trans(keeped_eigs, keeped_eigs);
        K0_D = K0_trans(decimated_eigs, decimated_eigs);
        W = K0_trans(keeped_eigs, decimated_eigs);
        K1_M = K1_trans(keeped_eigs, keeped_eigs);
        P = K1_trans(decimated_eigs, keeped_eigs);
        A = K1_pre(keeped_eigs, :);
        B = K1_pre(decimated_eigs, :);
        if rank(K0_D) ~= length(K0_D)
            max_perturbation = max(max(abs(K0_D))) * delta_SVD + delta_SVD;
            K0_D_rand = rand(length(K0_D));
            K0_D = K0_D + max_perturbation * (-1 + 2 * (K0_D_rand + K0_D_rand.'));
        end

        G0_D = -K0_D \ eye(length(K0_D));
        B_aux = K0 + B' * G0_D * B;
        A_aux = A + W * G0_D * B;
        K0 = K0_M + W * G0_D * W' + P' * G0_D * P;
        K1 = K1_M + W * G0_D * P;
        K1 = K1 + min_eig * (-1 + 2 * (rand(length(K1)) + 1i * rand(length(K1))));

        S0_trans = V' * S0 * V;
        S1_trans = V' * S1 * V;
        SA = S0_trans(keeped_eigs, keeped_eigs);
        SB = S0_trans(decimated_eigs, keeped_eigs);
        SC = S0_trans(decimated_eigs, decimated_eigs);
        SD = S1_trans(keeped_eigs, keeped_eigs);
        SF = S1_trans(decimated_eigs, keeped_eigs);
        S0 = SA + W * G0_D * SB + SB' * G0_D * W' + W * G0_D * SC * G0_D * W' ...
            + P' * G0_D * SC * G0_D * P + P' * G0_D * SF + SF' * G0_D * P;
        S1 = SD + SB' * G0_D * P + W * G0_D * SF + W * G0_D * SC * G0_D * P;
    end
end


function K1 = regularize_small_elements(K1, delta_SVD, N)
    if rank(K1) ~= N
      [U, eig_values, V] = svd(K1);
      eig_values = diag(eig_values);
      scaled_min_eig = delta_SVD * max(eig_values);
      eig_values(eig_values < scaled_min_eig) = scaled_min_eig;
      eig_values = diag(eig_values);
      K1 = U * eig_values * V';
    end
end


function K1 = add_small_imaginary(K1, delta_SVD)
    max_perturbation = delta_SVD * max(max(abs(K1)));
    K1 = K1 + max_perturbation * (1i * rand(length(K1)));
end










