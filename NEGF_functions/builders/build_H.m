function H = build_H(G, mat, contact_id)
%build_H build H matrix of NEGF method
    
    G = G_nodes_by_id(G, contact_id);
    alpha = mat.epsilon * eye(numnodes(G));
    beta_aux = triu(full(adjacency(G)));
    beta_upper = mat.t * beta_aux;
    beta_lower = mat.t' * beta_aux';
    H = alpha + beta_upper + beta_lower;
end

