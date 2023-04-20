function G = G_nodes_by_id(G, contact_id)
%G_nodes_by_id get all nodes according contact_id

    G = subgraph(G, find(G.Nodes.contact_id == contact_id));
end