function [alpha, beta, tau] = def_periodic_structures(G, contact_trans_dir, a, epsilon, t)
%def_periodic_structures calculate periodic structures in contacts

    alpha = {};
    beta = {};
    tau = {};

    all_regions = unique(G.Nodes.contact_id);
    contact_ids = all_regions(all_regions ~= 0);
    
    for i=1:length(contact_ids)
        H = create_subregions(G, contact_ids(i,:));
        H_matrix = full(adjacency(H));
        H_matrix = triu(H_matrix);
        H_dir = digraph(H_matrix);
        H_dir.Nodes = H.Nodes;
        bound_nodes = H.Nodes(H.Nodes.bound == 1, 1:2);
        trans_dir = contact_trans_dir(i,:);
        chosen_candidates = find_period(H, bound_nodes, trans_dir, a);

        periodic_nodes = [];
        for bound_node=bound_nodes.Name'
            periodic_nodes = graph_search(H_dir, string(bound_node), chosen_candidates, periodic_nodes);
        end
        periodic_nodes = unique(periodic_nodes);
        G_periodic = subgraph(H, matches(H.Nodes.Name, periodic_nodes));
        alpha{end + 1} = build_alpha(G_periodic, epsilon, t);
        beta{end + 1} = build_beta(H_dir, chosen_candidates, periodic_nodes, t);
        tau{end + 1} = build_tau(G, periodic_nodes, t);
    end
end


function chosen_candidates = find_period(H, bound_nodes, trans_dir, a)
    chosen_candidates = [];
    quadrature_dir = find(~trans_dir);
    quadrature_coords = H.Nodes.coord(:, quadrature_dir);
    [~, min_quadrature_coord_pos] = min(bound_nodes.coord(:, quadrature_dir));
    min_node = bound_nodes(min_quadrature_coord_pos, :);
    visited_nodes = [min_node.Name{1}];
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
            visited_nodes = [visited_nodes; candidate_name{1}];
            break;
        end
    end
    next_candidate = period_candidates(i,:);
end


function [candidate_status, chosen_candidates] = check_candidate(...
    H, bound_nodes, candidate, min_node, a)
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


function beta = build_beta(H_dir, chosen_candidates, periodic_nodes, t)
    beta = zeros(length(periodic_nodes));
    beta_nodes = {};
    for candidate=chosen_candidates
        preds = predecessors(H_dir, candidate);
        is_periodic = find(ismember(preds, periodic_nodes));
        if is_periodic
            beta_nodes{end + 1} = [preds(is_periodic) candidate];
        end
    end
    for node=beta_nodes
        beta(node{1}(1) == periodic_nodes, node{1}(2) == chosen_candidates) = t;
    end
end


function tau = build_tau(G, periodic_nodes, t)
    channel_nodes = string(table2array(G.Nodes(G.Nodes.contact_id == 0, "Name")));
    rows = [];
    columns = [];
    values = [];
    for i=1:length(periodic_nodes)
        neigs = neighbors(G, periodic_nodes(i));
        neigs = channel_nodes(matches(channel_nodes, neigs));
        for neig=neigs'
            rows = [rows, str2double(neig)];
            columns = [columns, i];
            values = [values, t];
        end
    end
    tau = full(sparse(rows, columns, values, height(channel_nodes), length(periodic_nodes)));
end

