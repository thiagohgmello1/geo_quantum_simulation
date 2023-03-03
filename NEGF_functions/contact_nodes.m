function [left_contact, right_contact] = contact_nodes(G)
%contact_nodes define what nodes belongs to contacts

    left_contact = find_indices_by_coord(G, 1);
    right_contact = find_indices_by_coord(G, numnodes(G));
end

