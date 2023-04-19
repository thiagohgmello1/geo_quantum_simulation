function H = build_H(G_dir, epsilon, t)
%build_H build H matrix of NEGF method

    alpha = epsilon * eye(numnodes(G_dir));
    beta_aux = full(adjacency(G_dir));
    beta_upper = t * beta_aux;
    beta_lower = t' * beta_aux';
    H = alpha + beta_upper + beta_lower;
end

