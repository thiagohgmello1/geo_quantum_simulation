function [K0_eff, K1_eff, K_1_eff] = regularize_matrices2(K0, K1, S0, S1, varargin)
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
        [~, U, S, V] = calc_svd(K1, N, delta_SVD);
        [K0_eff, K1_eff, K_1_eff] = reduce_matrix_size2(K0, U, S, V, delta_SVD, N);
%         K1_eff = regularize_small_elements(K1_eff, delta_SVD, N);
%         K1_eff = add_small_imaginary(K1_eff, delta_SVD);
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
%     M = length(decimated_sing_values);
%     N_eff = length(keeped_sing_values);

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





