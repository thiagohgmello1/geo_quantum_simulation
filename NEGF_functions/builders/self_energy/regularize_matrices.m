function [K0, K1, S0, S1, V, values] = regularize_matrices(K0, K1, S0, S1, varargin)
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
    values = {};
    if rank(K1) ~= N || abs(det(K1)) < det_tol
        [K1, U, S, V] = calc_svd(K1, N, delta_SVD);
%         [K0, K1, S0, S1, values] = reduce_matrix_size(K0, K1, S0, S1, U, S, V, delta_SVD, N);
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
        [U , S, V] = svd(K1);
        S = diag(S);
    end
end


function [min_eig, keep_values, decimate_values, S] = set_min_eigs(S, delta_SVD, N)
    min_eig = delta_SVD * max(S);
    keep_values = find(S > min_eig);
    decimate_values = setdiff(1:N, keep_values);
    S(decimate_values) = 0;
end


function [K0, K1, S0, S1, values] = reduce_matrix_size(K0, K1, S0, S1, U, S, V, delta_SVD, N)
    [min_eig, keep_values, decimate_values, ~] = set_min_eigs(S, delta_SVD, N);
    values = {keep_values, decimate_values};
    K0_trans = V' * K0 * V;
    K1_trans = V' * K1 * V;

    K0_M = K0_trans(keep_values, keep_values);
    K0_D = K0_trans(decimate_values, decimate_values);
    W = K0_trans(keep_values, decimate_values);
    K1_M = K1_trans(keep_values, keep_values);
    P = K1_trans(decimate_values, keep_values);

    if rank(K0_D) ~= length(K0_D)
        max_perturbation = max(max(abs(K0_D))) * delta_SVD + delta_SVD;
        K0_D_rand = rand(length(K0_D));
        K0_D = K0_D + max_perturbation * (-1 + 2 * (K0_D_rand + K0_D_rand.'));
    end

    K0_D_inv = K0_D \ eye(length(K0_D));
    K0 = K0_M - W' * K0_D_inv * W - P' * K0_D_inv * P;
    K1 = K1_M - W' * K0_D_inv * P;
    % Add small complex random values
    K1 = K1 + min_eig * (-1 + 2 * (rand(length(K1)) + 1i * rand(length(K1))));

    S0_trans = V' * S0 * V;
    S1_trans = V' * S1 * V;
    A = S0_trans(keep_values, keep_values);
    B = S0_trans(decimate_values, keep_values);
    C = S0_trans(decimate_values, decimate_values);
    D = S1_trans(keep_values, keep_values);
    E = S1_trans(decimate_values, keep_values);

    S0 = A - W' * K0_D_inv * B + B' * K0_D_inv * W + W' * K0_D_inv * C * K0_D_inv * W ...
        + P' * K0_D_inv * C * K0_D_inv * P - P' * K0_D_inv * E - E' * K0_D_inv * P;
    S1 = D - B' * K0_D_inv * P - W' * K0_D_inv * E + W' * K0_D_inv * C * K0_D_inv * P;
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










