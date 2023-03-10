function [undir_G, dir_G] = create_graph(nodes, n_sides)
%create_graph create graph from specific nodes connections
    
    total_nodes = length(nodes);
    undir_graph_matrix = zeros(total_nodes);
    dir_graph_matrix = zeros(total_nodes);
    node_names = 1:total_nodes;
    node_names = cellstr(num2str(node_names'));
    nodes_coords = vertcat(nodes.coord);
    nodes_colors = vertcat(nodes.color);
    nodes_bounds = vertcat(nodes.is_bound);
    
    for i=1:total_nodes
        actual_node = nodes(i).id;
        neighbors = nodes(i).neighbors;
        total_neighbors = length(neighbors);
        for j=1:total_neighbors
            neighbor = neighbors(j);
            dir_graph_matrix(actual_node, neighbor) = true;
            undir_graph_matrix(actual_node, neighbor) = true;
        end
    end
    dir_graph_matrix = triu(dir_graph_matrix);
    
    undir_G = graph(undir_graph_matrix~=0);
    dir_G = digraph(dir_graph_matrix~=0);

    undir_G.Nodes.bounds = nodes_bounds;
    undir_G.Nodes.color = nodes_colors;
    undir_G.Nodes.coord = nodes_coords;

    dir_G.Nodes.bounds = nodes_bounds;
    dir_G.Nodes.color = nodes_colors;
    dir_G.Nodes.coord = nodes_coords;

    [undir_G, dir_G] = build_boundary(undir_G, dir_G, n_sides);
    
    undir_G.Nodes.Name = node_names;
    dir_G.Nodes.Name = node_names;
end

