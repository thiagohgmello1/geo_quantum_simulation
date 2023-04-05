function [sigma_left,sigma_right] = build_self_energy(G, epsilon, t, energy, eta, stop_cond, bounds, G_contact)
%build_self_energy build self energy matrices for contacts
    
    stop_cond = 1e-4;

    
    func_ids = unique([G_contact.Nodes.func_id]);
    contacts_ids = func_ids(func_ids ~= int8(0));
    
    for cont_id=contacts_ids'
        channel_nodes = bounds.boundaries.dir(cont_id).nodes;
        cont_nodes = G_contact.Nodes.Name(G_contact.Nodes.func_id == cont_id);
        H_contact = subgraph(G_contact, cont_nodes);
        M = full(adjacency(H_contact));
        beta = triu(M, 1) * t;
        alpha = eye(length(M)) * epsilon;
        conn_channel_nodes = find_channel_contacts(G_contact, cont_nodes);
        tau = build_tau(channel_nodes, conn_channel_nodes, length(channel_nodes), numnodes(H_contact), cont_nodes, t);
        gn = iterate_gn(alpha, beta, energy, eta, stop_cond);
        sigma = tau * gn * tau';
    end

    [left_contact, right_contact] = contact_nodes(G, bounds);

    M_left = eye(length(left_contact));
    vec_left = ones(1,length(M_left) - 1);
    M_right = eye(length(right_contact));
    vec_right = ones(1,length(M_right) - 1);

    alpha_left = -epsilon * M_left + t * diag(vec_left, 1) + t * diag(vec_left, -1);
    alpha_right = epsilon * M_right + t * diag(vec_right, 1) + t * diag(vec_right, -1);

    beta_left = t * M_left;
    beta_right = t * M_right;

    gn_left = iterate_gn(alpha_left, beta_left, energy, eta, stop_cond);
    gn_right = iterate_gn(alpha_right, beta_right, energy, eta, stop_cond);
    
    sigma_left = beta_left' * gn_left * beta_left;
    sigma_left = complete_sigma_matrix(sigma_left, left_contact, numnodes(G));
    sigma_right = beta_right * gn_right * beta_right';
    sigma_right = complete_sigma_matrix(sigma_right, right_contact, numnodes(G));
end


function gn = iterate_gn(alpha, beta, energy, eta, stop_cond)
    M_aux = eye(length(alpha));
    z = (energy + 1i*eta) * M_aux - alpha;
    change = 1;
    gn = inv(z);
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


function channel_nodes = find_channel_contacts(G_contact, cont_nodes)
    channel_nodes = [];
    for cont_node=str2num(cell2mat(cont_nodes))'
        neigs = neighbors(G_contact, string(cont_node));
        for neig=neigs'
            channel = find(and(contains(G_contact.Nodes.Name, neig), (G_contact.Nodes.func_id == int8(0))));
            ch = [channel, cont_node];
            if channel
                channel_nodes = [channel_nodes; ch];
            end
            
        end
    end
end


function tau = build_tau(channel_nodes, conn_channel_nodes, channel_size, contact_size, cont_nodes, t)
    tau = zeros(channel_size, contact_size);
    [~, channel_pos] = ismember(conn_channel_nodes(:,1), channel_nodes);
    [~, cont_pos] = ismember(conn_channel_nodes(:,2), str2num(cell2mat(cont_nodes)));
    for i=1:length(channel_pos)
        tau(channel_pos(i), cont_pos(i)) = t';
    end
end












