function G_concat = attach_contacts(G_contacts, G, a, polygon_plot)
%attach_contacts attach contacts to system
    
    repeated_nodes = [];
    neig_nodes = [];
    for contact=G_contacts
        [neig_node, repeated_node] = get_repeated_nodes(contact{1}, G, a);
        repeated_nodes = [repeated_nodes; repeated_node];
        neig_nodes = [neig_nodes; neig_node];
    end
    G_concat = concat_graphs(G_contacts, G);
    G_concat = connect_contacts(G_concat, neig_nodes);
    G_concat = remove_repeated_nodes(G_concat, repeated_nodes, neig_nodes);
    G_concat = add_exceptional_bound_nodes(G_concat);
    G_concat = reorganize_bounds(G_concat, polygon_plot);
    G_concat = complete_boundaries(G_concat);
    G_concat = add_exceptional_bound_nodes(G_concat);
end


function [neig_nodes, repeated_node] = get_repeated_nodes(G_contact, G, a)
% Get all repeated nodes (identify superposition)
    neig_nodes = [];
    repeated_node = [];
    G_coord = vertcat(G.Nodes.coord);
    contact_coord = vertcat(G_contact.Nodes.coord);
    for i=1:length(contact_coord)
        channel_node = find(all(is_close(contact_coord(i,:), G_coord, 'rtol', 0, 'atol', a / 2), 2));
        channel_node = findnode(G, string(channel_node));
        if channel_node
            repeated_node = [repeated_node; [G_contact.Nodes.Name(i) string(channel_node)]];
            neig = neighbors(G_contact, G_contact.Nodes.Name(i));
            G_array = repmat(string(G.Nodes.Name(channel_node)),length(neig),1);
            neig_nodes = [neig_nodes; [neig, G_array]];
        end
    end
end


function G_concat = concat_graphs(G_contacts, G)
% Concatenate graphs
    cont_id_counter = int8(0);
    G_matrix = full(adjacency(G));
    channel_color = [0 0 1];
    contact_color = [1 0 0];
    names = G.Nodes.Name;
    coords = G.Nodes.coord;
    colors = repmat(channel_color, length(names), 1);
    contact_id = zeros(length(names), 1);
    center_id = G.Nodes.center_id;

    for contact=G_contacts
        cont_id_counter = cont_id_counter + int8(1);
        G_len = length(G_matrix);
        G_contact = contact{1};
        contact_len = numnodes(G_contact);
        contact_matrix = full(adjacency(G_contact));
        G_matrix(G_len + 1:contact_len + G_len,G_len + 1:contact_len + G_len) = contact_matrix;

        names = [names; G_contact.Nodes.Name];
        coords = [coords; G_contact.Nodes.coord];
        colors = [colors; repmat(contact_color, length(G_contact.Nodes.coord), 1);];
        contact_id = [contact_id; repmat(cont_id_counter, length(G_contact.Nodes.coord), 1)];
        center_id = [center_id; G_contact.Nodes.center_id];
    end
    G_concat = graph(G_matrix);
    names = cellstr(string(1:numnodes(G_concat)))';
    boundaries = false(numnodes(G_concat), 1);
    G_concat.Nodes.Name = names;
    G_concat.Nodes.coord = coords;
    G_concat.Nodes.color = colors;
    G_concat.Nodes.bound = boundaries;
    G_concat.Nodes.contact_id = contact_id;
    G_concat.Nodes.center_id = center_id;
end


function G = connect_contacts(G_concat, neig_nodes)
% Connect contacts to channel
    s = strtrim(neig_nodes(:,1));
    t = strtrim(neig_nodes(:,2));
    w = ones(length(s), 1);
    G = addedge(G_concat, s, t, w);
end


function G = remove_repeated_nodes(G, repeated_nodes, neig_nodes)
% Remove all repeated nodes
    contact_nodes = strtrim(repeated_nodes(:,1))';
    channel_nodes = strtrim(repeated_nodes(:,2))';
    for i=1:length(contact_nodes)
        contact_center_ids = G.Nodes(findnode(G, string(contact_nodes(i))),:).center_id;
        channel_center_ids = G.Nodes(findnode(G, string(channel_nodes(i))),:).center_id;

        new_center_ids = cellfun(@(v)unique([v, contact_center_ids{1}]), channel_center_ids, 'UniformOutput', false);
        G.Nodes(findnode(G, channel_nodes(i)),:).center_id = new_center_ids;

        neig_nodes = neig_nodes(arrayfun(@(j)isempty(regexp(neig_nodes(j,1),...
            contact_nodes(i), 'once')), 1:size(neig_nodes,1)),:);
        
        G = rmnode(G, string(contact_nodes(i)));
    end
    G.Nodes(findnode(G, neig_nodes(:,1)),:).bound = true(length(neig_nodes), 1);
end


function G = complete_boundaries(G)
    all_center_ids = G.Nodes.center_id;
    channel_nodes = ~G.Nodes.contact_id;
    center_ids = G.Nodes(G.Nodes.bound == true,:).center_id;
    contact_nodes = G.Nodes.contact_id > 0;
    bound_centers = [];
    for i=1:length(center_ids)
        center_ids_aux = center_ids(i);
        center_ids_aux = center_ids_aux{1};
        for center_id=center_ids_aux
            pos = cell2mat(cellfun(@(v)any(ismember(v, center_id)), all_center_ids, 'UniformOutput', false));
            channel_bounds = pos & channel_nodes;
            contact_bounds = pos & contact_nodes;
            bound_nodes = any(channel_bounds) & any(contact_bounds);
            if bound_nodes && ~ismember(center_id, bound_centers)
                bound_centers = [bound_centers center_id];
                G.Nodes(contact_bounds,:).bound = true(nnz(contact_bounds), 1);
            end
        end
    end
end

% New method. Doesn't work for ACNR. Find a way to consider a transition
% region (orientated by transversal system vector)
function G = reorganize_bounds(G, polygon)
    contact_ids = nonzeros(unique(G.Nodes.contact_id));
    default_channel_data = G.Nodes(G.Nodes.contact_id == 0, ["color", "bound", "contact_id"]);
    default_channel_data = default_channel_data(1,:);
    for contact=contact_ids'
        contact_nodes = G.Nodes(and(G.Nodes.contact_id == contact, G.Nodes.bound == true), [1, 2]);
        nodes_id = contact_nodes(:, 1);
        nodes_coords = table2array(contact_nodes(:, 2));
        nodes_inside_poly = nodes_id(inpolygon(nodes_coords(:, 1), nodes_coords(:, 2), polygon(:, 1), polygon(:, 2)),:);
        for node=table2array(nodes_inside_poly)'
            node_pos = findnode(G, node{1});
            bound_neigs = neighbors(G, node_pos)';
            new_bound_nodes = bound_neigs(logical(G.Nodes(bound_neigs, "contact_id").Variables));
            G.Nodes(new_bound_nodes, "bound") = {true};
            G.Nodes(node_pos, ["color", "bound", "contact_id"]) = default_channel_data;
        end
    end
end


function G = add_exceptional_bound_nodes(G)
    already_bound_nodes = G.Nodes(G.Nodes.bound == true, "Name");
    rows = height(already_bound_nodes);
    channel_nodes = table2cell(G.Nodes(G.Nodes.contact_id == 0, "Name"));
    for i=1:rows
        bound_neigs = neighbors(G, already_bound_nodes{i, 1}{1});
        neigs_cond = cell2mat(cellfun(@(node) and(ismember(node, bound_neigs), ...
            length(neighbors(G ,node)) == 2), G.Nodes.Name, 'UniformOutput', false));
        check_neigs = cell2mat(cellfun(@(v) any(ismember(v, channel_nodes)), bound_neigs, 'UniformOutput', false));
        if ~any(neigs_cond) || ~any(check_neigs)
            continue
        end
        non_channel_nodes = G.Nodes.contact_id ~= 0;
        nodes = and(neigs_cond, non_channel_nodes);
        if any(nodes)
            G.Nodes(nodes, "bound").Variables = true;
        end
    end
    

end




