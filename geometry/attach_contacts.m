function G_leads = attach_contacts(nodes, G)
%attach_contacts attach contacts to system
    
    [undir_G, dir_G] = create_graph(nodes, 6, 'name_offset', numnodes(G));
    
end