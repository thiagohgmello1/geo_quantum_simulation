function H = build_H(dir_G, epsilon, t)
%build_H build H matrix of NEGF method

    alpha = epsilon * eye(numnodes(dir_G));
    beta_aux = full(adjacency(dir_G));
    beta_upper = t * beta_aux;
    beta_lower = t' * beta_aux';
    H = alpha + beta_upper + beta_lower;
end

