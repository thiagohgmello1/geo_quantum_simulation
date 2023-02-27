function nodes_graph = create_graph(nodes)
%create_graph create graph from specific nodes connections
    
    total_nodes = length(nodes);
    graph_matrix = zeros(total_nodes);
    node_names = 1:total_nodes;
    node_names = cellstr(num2str(node_names'));
    
    for i=1:total_nodes
        actual_node = nodes(i).id;
        neighbors = nodes(i).neighbors;
        total_neighbors = length(neighbors);
        for j=1:total_neighbors
            neighbor = neighbors(j);
            graph_matrix(actual_node, neighbor) = true;
            graph_matrix(neighbor, actual_node) = true;
        end
    end
    nodes_graph = graph(graph_matrix~=0, node_names);
end

