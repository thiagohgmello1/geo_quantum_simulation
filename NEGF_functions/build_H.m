function H = build_H(G, epsilon, t, contact_id)
%build_H build H matrix of NEGF method
    
    G = G_nodes_by_id(G, contact_id);
    alpha = epsilon * eye(numnodes(G));
    beta_aux = triu(full(adjacency(G)));
    beta_upper = t * beta_aux;
    beta_lower = t' * beta_aux';
    H = alpha + beta_upper + beta_lower;
end

