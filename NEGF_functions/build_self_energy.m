function [sigma_left,sigma_right] = build_self_energy(G, epsilon, t, energy, eta, stop_cond)
%build_self_energy build self energy matrices for contacts
    
    if nargin < 6
        stop_cond = 1e-4;
    end

    [left_contact, right_contact] = contact_nodes(G);

    M_left = eye(length(left_contact));
    vec_left = ones(1,length(M_left) - 1);
    M_right = eye(length(right_contact));
    vec_right = ones(1,length(M_right) - 1);

    alpha_left = epsilon * M_left + t * diag(vec_left, 1) + t * diag(vec_left, -1);
    alpha_right = epsilon * M_right + t * diag(vec_right, 1) + t * diag(vec_right, -1);

    beta_left = t * M_left;
    beta_right = t * M_right;

    gn_left = iterate_gn(alpha_left, beta_left, energy, eta, stop_cond);
    gn_right = iterate_gn(alpha_right, beta_right, energy, eta, stop_cond);
    
    sigma_left = beta_left * gn_left * beta_left';
    sigma_left = complete_sigma_matrix(sigma_left, left_contact, numnodes(G));
    sigma_right = beta_right * gn_right * beta_right';
    sigma_right = complete_sigma_matrix(sigma_right, right_contact, numnodes(G));
end


function gn = iterate_gn(alpha, beta, energy, eta, stop_cond)
    z = (energy + 1i*eta) * eye(length(alpha)) - alpha;
    change = 1;
    gn = inv(z);
    M_aux = eye(length(alpha));
    while change > stop_cond
        B = z - beta' * gn * beta;
        gn1 = B \ M_aux;
        change = sum(sum(abs(gn1 - gn)))/(sum(sum(abs(gn) + abs(gn1))));
        gn = 0.5 * gn1 + 0.5 * gn;
    end
end


function sigma = complete_sigma_matrix(partial_sigma, real_pos, sigma_len)
    sigma = zeros(sigma_len);
    for i=1:length(real_pos)
        real_i = real_pos(i);
        for j=1:length(real_pos)
            real_j = real_pos(j);
            sigma(real_i, real_j) = partial_sigma(i, j);
        end
    end
end













