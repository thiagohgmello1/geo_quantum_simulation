function G_dir = create_digraph(G)
%create_digraph create a direct graph based on a undirected graph

    G_data = G.Nodes;
    G_matrix = triu(full(adjacency(G)));
    G_dir = digraph(G_matrix);
    G_dir.Nodes = G_data;
end