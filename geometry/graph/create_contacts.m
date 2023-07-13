function [G_contacts, G_contacts_dir] = create_contacts(G, mat, system)
%create_contacts Create contacts from specified Dirichlet boundaries

    G_contacts = {};
    G_contacts_dir = {};
    id_offset = numnodes(G);
    center_id_offset = length(allcycles(G, 'MaxCycleLength', mat.n_sides));
    for dir_bound=system.boundaries.dir
        [G_contact, G_contact_dir] = create_contact(G, dir_bound, mat.n_sides, mat.a, ...
            'angle', mat.angle, 'id_offset', id_offset, 'center_id_offset', center_id_offset);
        id_offset = id_offset + numnodes(G_contact);
        center_id_offset = center_id_offset + length(allcycles(G_contact, 'MaxCycleLength', mat.n_sides));
        G_contacts{end + 1} = G_contact;
        G_contacts_dir{end + 1} = G_contact_dir;
    end
end