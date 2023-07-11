function [K, S, Fn, len] = regularize_matrices(K0, K1, S0, S1, varargin)
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
    
    len = struct();
    len.N = length(K1);

    if rank(K1) ~= len.N || abs(det(K1)) < det_tol
        [K, S, Fn] = reduce_matrix_size(K0, K1, S0, S1, delta_SVD, len.N);
%         K1 = regularize_small_elements(K1, delta_SVD, N);
%         K1 = add_small_imaginary(K1, delta_SVD);
    else
        K = struct();
        K.K0_eff = K0;
        K.K1_eff = K1;
        K.Km1_eff = K1';

        S = struct();
        S.S0_eff = S0;
        S.S1_eff = S1;
        S.Sm1_eff = S1';
    end
    len.N_eff = length(K.K1_eff);
end


function [min_eig, keep_values, replace_values, S] = set_min_eigs(S, delta_SVD, N)
    min_eig = delta_SVD * max(S);
    keep_values = find(S >= min_eig);
    replace_values = setdiff(1:N, keep_values);
    S(replace_values) = 0;
end


function [K, overlap, Fn] = reduce_matrix_size(K0, K1, S0, S1, delta_SVD, N)
    [U, S, V] = svd(K1);
    S = diag(S);
    [~, keep, replace, S] = set_min_eigs(S, delta_SVD, N);
    K1_SVD = U * diag(S) * V';
    
    K0_trans = U' * K0 * U;
    K1_trans = U' * K1_SVD * U;

    S0_trans = U' * S0 * U;
    S1_trans = U' * S1 * U;

    K1c = K1_trans(keep, keep);
    K1u = K1_trans(keep, replace);
    
    A = K0_trans(keep, keep);
    B = K0_trans(keep, replace);
    C = K0_trans(replace, keep);
    D = K0_trans(replace, replace);
    minus_D_inv = -D \ eye(length(D));

    S1c = S1_trans(keep, keep);
    S1u = S1_trans(keep, replace);

    E = S0_trans(keep, keep);
    F = S0_trans(keep, replace);
    G = S0_trans(replace, keep);
    H = S0_trans(replace, replace);

    K0_eff = A + B * minus_D_inv * C + K1u * minus_D_inv * K1u';
    K1_eff = K1c + K1u * minus_D_inv * C;
    Km1_eff = K1c' + B * minus_D_inv * K1u';

    K = struct();
    K.K0 = K0;
    K.K0_eff = K0_eff;
    K.K1_eff = K1_eff;
    K.Km1_eff = Km1_eff;

    S0_eff = E + C' * minus_D_inv' * G + K1u * minus_D_inv' * S1u' + ...
        F * minus_D_inv * C + S1u * minus_D_inv * K1u + C' * minus_D_inv' * H * minus_D_inv * C + ...
        K1u + minus_D_inv' * H * minus_D_inv * K1u';
    S1_eff = S1c + K1u * minus_D_inv' * G + S1u * minus_D_inv * C + K1u * minus_D_inv' * H * minus_D_inv * C;
    Sm1_eff = S1c' + C' * minus_D_inv' * S1u' + F * minus_D_inv * K1u' + C' * minus_D_inv' * H * minus_D_inv * K1u';

    overlap = struct();
    overlap.S0_eff = S0_eff;
    overlap.S1_eff = S1_eff;
    overlap.Sm1_eff = Sm1_eff;

    Fn = struct();
    Fn.minus_D_inv = minus_D_inv;
    Fn.Km1u = K1u';
    Fn.C = C;
    Fn.U = U;
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


