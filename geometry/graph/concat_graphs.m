function [G_concat] = concat_graphs(varargin)
%concat_graphs Concatenate all n graphs
    
    G_data = table();
    G_matrix = [];
    for G=varargin{:}
        G = G{1};
        G_data = [G_data; G.Nodes];
        G_aux = full(adjacency(G));
        aux_len = length(G_aux);
        G_matrix(end+1:end+aux_len, end+1:end+aux_len) = G_aux;
    end
    G_concat = digraph(G_matrix);
    G_concat.Nodes = G_data;
%     create_graph(G_data, 6, 78);
end




function G_concat = ei(G_contacts, G)
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
%         contacts = [contacts; true(length(G_contact.Nodes.coord), 1)];
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