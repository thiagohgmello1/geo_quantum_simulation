function G_concat = attach_contacts(G_contacts, G, a)
%attach_contacts attach contacts to system
    
    repeated_nodes = [];
    neig_nodes = [];
    for contact=G_contacts
        [neig_node, repeated_node] = get_repeated_nodes(contact{1}, G, a);
        repeated_nodes = [repeated_nodes, repeated_node];
        neig_nodes = [neig_nodes; neig_node];
    end
    G_concat = concat_graphs(G_contacts, G);
    G_concat = connect_contacts(G_concat, neig_nodes);
    G_concat = remove_repeated_nodes(G_concat, repeated_nodes);
end


function [neig_nodes, repeated_node] = get_repeated_nodes(G_contact, G, a)
    neig_nodes = [];
    repeated_node = [];
    G_coord = vertcat(G.Nodes.coord);
    contact_coord = vertcat(G_contact.Nodes.coord);
    for i=1:length(contact_coord)
        already_pos = find(all(is_close(contact_coord(i,:), G_coord, 'rtol', 0, 'atol', a / 2), 2));
        if already_pos
            repeated_node = [repeated_node G_contact.Nodes.Name(i)];
            neig = neighbors(G_contact, G_contact.Nodes.Name(i));
            G_array = repmat(string(G.Nodes.Name(already_pos)),length(neig),1);
            neig_nodes = [neig_nodes; [neig, G_array]];
        end
    end
end


function G_concat = concat_graphs(G_contacts, G)
    func_counter = int8(0);
    G_matrix = full(adjacency(G));
    channel_color = [0 0 1];
    contact_color = [1 0 0];
    names = G.Nodes.Name;
    coords = G.Nodes.coord;
    colors = repmat(channel_color, length(names), 1);
    contacts = false(length(names), 1);
    func = zeros(length(names), 1);

    for contact=G_contacts
        func_counter = func_counter + int8(1);
        G_len = length(G_matrix);
        G_contact = contact{1};
        contact_len = numnodes(G_contact);
        contact_matrix = full(adjacency(G_contact));
        G_matrix(G_len+1:contact_len+G_len,G_len+1:contact_len+G_len) = contact_matrix;

        names = [names; G_contact.Nodes.Name];
        coords = [coords; G_contact.Nodes.coord];
        colors = [colors; repmat(contact_color, length(G_contact.Nodes.coord), 1);];
        contacts = [contacts; true(length(G_contact.Nodes.coord), 1)];
        func = [func; repmat(func_counter, length(G_contact.Nodes.coord), 1)];
    end
    G_concat = graph(G_matrix);
    G_concat.Nodes.Name = names;
    G_concat.Nodes.coord = coords;
    G_concat.Nodes.color = colors;
    G_concat.Nodes.cont = contacts;
    G_concat.Nodes.func_id = func;
end


function G = connect_contacts(G_concat, neig_nodes)
    s = neig_nodes(:,1);
    t = neig_nodes(:,2);
    w = ones(length(s), 1);
    G = addedge(G_concat, s, t, w);
end


function G = remove_repeated_nodes(G, repeated_nodes)
    for node=repeated_nodes
        G = rmnode(G, node{1});
    end
end





