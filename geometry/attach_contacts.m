function a = attach_contacts(contacts, G)
%attach_contacts attach contacts to system
    
    channel_nodes_coord = vertcat(G.Nodes.coord);
    for contact=contacts
        contact_nodes_coord = vertcat(contact{1}.Nodes.coord);
    end
    
end