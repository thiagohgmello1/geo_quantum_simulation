function G_contacts = create_contacts(G, n_sides, system, a, graphene_angle)
%create_contacts Create contacts from specified Dirichlet boundaries

    G_contacts = {};
    id_offset = numnodes(G);
    center_id_offset = length(allcycles(G, 'MaxCycleLength', n_sides));
    for dir_bound=system.boundaries.dir
        G_contact = create_contact(G, dir_bound, n_sides, a, ...
            'angle', graphene_angle, 'id_offset', id_offset, 'center_id_offset', center_id_offset);
        id_offset = id_offset + numnodes(G_contact);
        center_id_offset = center_id_offset + length(allcycles(G_contact, 'MaxCycleLength', n_sides));
        G_contacts{end + 1} = G_contact;
    end
end