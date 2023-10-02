function periodic_structs = def_periodic_structures(G_complete, system, a, epsilon, t)
%def_periodic_structures calculate periodic structures in contacts

    alpha = {};
    beta = {};
    tau = {};

    all_regions = unique(G_complete.Nodes.contact_id);
    contact_ids = all_regions(all_regions ~= 0);

    contact_params = [system.boundaries.dir.params];
    contact_trans_dir = vertcat(contact_params.trans_dir);
    
    for i=1:length(contact_ids)
        G_contact = create_subregions(G_complete, contact_ids(i,:));
        G_matrix = full(adjacency(G_contact));
        G_matrix = triu(G_matrix);
        G_contact_dir = digraph(G_matrix);
        G_contact_dir.Nodes = G_contact.Nodes;
        bound_nodes = G_contact.Nodes(G_contact.Nodes.bound == 1, 1:2);
        trans_dir = contact_trans_dir(i,:);
        chosen_candidates = find_period(G_contact, bound_nodes, trans_dir, a);

        periodic_nodes = [];
        for bound_node=bound_nodes.Name'
            periodic_nodes = graph_search(G_contact_dir, string(bound_node), chosen_candidates, periodic_nodes);
        end
        periodic_nodes = string(unique(str2double(periodic_nodes)));

        G_periodic = subgraph(G_contact, matches(G_contact.Nodes.Name, periodic_nodes));
        alpha{end + 1} = build_alpha(G_periodic, epsilon, t);
        beta{end + 1} = build_beta(G_contact_dir, chosen_candidates, periodic_nodes, t);
        tau{end + 1} = build_tau(G_complete, periodic_nodes, t);
    end
    periodic_structs = {};
    periodic_structs.alpha = alpha;
    periodic_structs.beta = beta;
    periodic_structs.tau = tau;
end


function chosen_candidates = find_period(H, bound_nodes, trans_dir, a)
    chosen_candidates = [];
    quadrature_dir = find(~trans_dir);
    quadrature_coords = H.Nodes.coord(:, quadrature_dir);
    [~, min_quadrature_coord_pos] = min(bound_nodes.coord(:, quadrature_dir));
    min_node = bound_nodes(min_quadrature_coord_pos, :);
    visited_nodes = [string(min_node.Name{1})];
    period_candidates = H.Nodes(is_close(quadrature_coords, ...
        min_node.coord(quadrature_dir), 'rtol', 0, 'atol', a / 10),:);

    while length(visited_nodes) < height(period_candidates)
        [next_candidate, visited_nodes] = choose_closer_candidate(...
            period_candidates, min_node, trans_dir, visited_nodes);
        [candidate_status, chosen_candidates] = check_candidate(H, bound_nodes, next_candidate, min_node, a);
        if candidate_status
            break;
        end
    end
end


function [next_candidate, visited_nodes] = choose_closer_candidate(...
    period_candidates, min_node, trans_dir, visited_nodes)
    dir_vectors = period_candidates.coord - min_node.coord;
    dir_vectors_cell = mat2cell(dir_vectors, ones(1, size(dir_vectors, 1)), 2);
    dot_prod = cellfun(@(v) dot(v, trans_dir), dir_vectors_cell);
    [~, min_ordering] = sortrows(dot_prod);
    right_dir = sign(dot_prod) > 0;
    non_checked_nodes = ~arrayfun(@(str) ismember(str, visited_nodes), period_candidates.Name);
    for i=min_ordering'
        if right_dir(i) && non_checked_nodes(i)
            candidate_name = period_candidates.Name(i);
            visited_nodes = [visited_nodes; string(candidate_name{1})];
            break;
        end
    end
    next_candidate = period_candidates(i,:);
end


function [candidate_status, chosen_candidates] = check_candidate(H, bound_nodes, candidate, min_node, a)
    diff_candidate = candidate.coord - min_node.coord;
    translated_bound = bound_nodes.coord + diff_candidate;
    checked_nodes = {};
    chosen_candidates = [];
    for i=1:length(translated_bound)
        bound_node = translated_bound(i,:);
        correspondence_node = all(is_close(H.Nodes.coord, bound_node, 'rtol', 0, 'atol', a / 10), 2);
        if any(correspondence_node)
            new_node = H.Nodes.Name(find(correspondence_node));
            chosen_candidates = [chosen_candidates string(new_node{1})];
            checked_nodes{end + 1} = [string(bound_nodes.Name{i}), string(new_node{1})];
        else
            break
        end
    end
    if length(checked_nodes) < height(bound_nodes)
        candidate_status = false;
    else
        candidate_status = true;
    end
end


function alpha = build_alpha(G_periodic, epsilon, t)
    G_matrix = full(adjacency(G_periodic));
    alpha = eye(numnodes(G_periodic)) * epsilon + t * triu(G_matrix) + t' * tril(G_matrix);
end


function beta = build_beta(G_contact_dir, chosen_candidates, periodic_nodes, t)
    beta = zeros(length(periodic_nodes));
    beta_nodes = {};
    for candidate=chosen_candidates
        preds = predecessors(G_contact_dir, candidate);
        is_periodic = find(ismember(preds, periodic_nodes));
        if is_periodic
            beta_nodes{end + 1} = [preds(is_periodic)' candidate];
        end
    end
    for node=beta_nodes
        % VERIFICAR QUAL BETA UTILIZAR
        beta(node{1}(1) == periodic_nodes, node{1}(2) == chosen_candidates) = t;
%         beta(node{1}(2) == chosen_candidates, node{1}(1) == periodic_nodes) = t;
    end
end


function tau = build_tau(G, periodic_nodes, t)
    G_channel = G_nodes_by_id(G, 0);
    channel_names = string(G_channel.Nodes.Name);
    rows = [];
    columns = [];
    values = [];
    for i=1:length(periodic_nodes)
        neigs = neighbors(G, periodic_nodes(i));
        neigs = channel_names(matches(channel_names, neigs));
        for neig=neigs'
            rows = [rows, findnode(G_channel, neig)];
            columns = [columns, i];
            values = [values, t];
        end
    end
    tau = full(sparse(rows, columns, values, numnodes(G_channel), length(periodic_nodes)));
end

