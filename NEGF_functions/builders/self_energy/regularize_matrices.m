function [K0, K1, S0, S1] = regularize_matrices(K0, K1, S0, S1, varargin)
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
%         [K0, K1, S0, S1] = reduce_matrix_size(K0, K1, S0, S1, U, S, V, delta_SVD, N);
        K1 = regularize_small_elements(K1, delta_SVD, N);
        K1 = add_small_imaginary(K1, delta_SVD);
    end
end


% Fix
function [K1, U, S, V] = calc_svd(K1, N, delta_SVD)
    max_perturbation = delta_SVD * max(max(abs(K1)));
    K1 = K1 + max_perturbation * (-1 + 2 * rand(N));
    [U , S, V] = svd(K1);
    S = diag(S);

%     try
%         [U, S, V] = svd(K1);
%         S = diag(S);
%     catch
%         max_perturbation = delta_SVD * max(max(abs(K1)));
%         K1 = K1 + max_perturbation * (-1 + 2 * rand(N));
%         [U , S, V] = svd(K1);
%         S = diag(S);
%     end
end


function [K0, K1, S0, S1] = reduce_matrix_size(K0, K1, S0, S1, U, S, V, delta_SVD, N)
    if rank(K1) ~= N
        min_eig = delta_SVD * max(S);
        keep_values = find(S > min_eig);
        decimate_values = setdiff(1:N, keep_values);
        K0_trans = V' * K0 * V;
        K1_trans = V' * K1 * V;
        K1_pre = V' * K1;

        K0_M = K0_trans(keep_values, keep_values);
        K0_D = K0_trans(decimate_values, decimate_values);
        W = K0_trans(keep_values, decimate_values);
        K1_M = K1_trans(keep_values, keep_values);
        P = K1_trans(decimate_values, keep_values);
        A = K1_pre(keep_values, :);
        B = K1_pre(decimate_values, :);
        if rank(K0_D) ~= length(K0_D)
            max_perturbation = max(max(abs(K0_D))) * delta_SVD + delta_SVD;
            K0_D_rand = rand(length(K0_D));
            K0_D = K0_D + max_perturbation * (-1 + 2 * (K0_D_rand + K0_D_rand.'));
        end

        G0_D = -K0_D \ eye(length(K0_D));
        K0 = K0_M + W * G0_D * W' + P' * G0_D * P;
        K1 = K1_M + W * G0_D * P;
        K1 = K1 + min_eig * (-1 + 2 * (rand(length(K1)) + 1i * rand(length(K1))));

        S0_trans = V' * S0 * V;
        S1_trans = V' * S1 * V;
        SA = S0_trans(keep_values, keep_values);
        SB = S0_trans(decimate_values, keep_values);
        SC = S0_trans(decimate_values, decimate_values);
        SD = S1_trans(keep_values, keep_values);
        SF = S1_trans(decimate_values, keep_values);
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










