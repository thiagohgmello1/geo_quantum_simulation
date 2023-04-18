function [G, G_dir] = create_graph(nodes, n_sides, varargin)
%create_graph create graph from specific nodes connections

    defaultNameOffset = 0;

    p = inputParser;
    validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x >= 0);
    addRequired(p,'nodes');
    addRequired(p,'n_sides');
    addOptional(p, 'id_offset', defaultNameOffset, validScalarPosNum);
    parse(p, nodes , n_sides, varargin{:});

    id_offset = p.Results.id_offset;
    
    if isa(nodes, "table")
        total_nodes = height(nodes);
    else
        total_nodes = length(nodes);
    end
    undir_graph_matrix = zeros(total_nodes);
    dir_graph_matrix = zeros(total_nodes);
    node_names = (1:total_nodes) + id_offset;
    node_names = cellstr(num2str(node_names'));
    nodes_coords = vertcat(nodes.coord);
    nodes_colors = vertcat(nodes.color);
    nodes_bounds = vertcat(nodes.is_bound);
    nodes_centers = vertcat(nodes.center);
    nodes_center_ids = struct2table(nodes).center_id;
    
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
    
    G = graph(undir_graph_matrix~=0);
    G_dir = digraph(dir_graph_matrix~=0);

    G.Nodes.bounds = nodes_bounds;
    G.Nodes.color = nodes_colors;
    G.Nodes.coord = nodes_coords;
    G.Nodes.center = nodes_centers;
    G.Nodes.center_id = nodes_center_ids;

    G_dir.Nodes.bounds = nodes_bounds;
    G_dir.Nodes.color = nodes_colors;
    G_dir.Nodes.coord = nodes_coords;
    G_dir.Nodes.center = nodes_centers;
    G_dir.Nodes.center_id = nodes_center_ids;

    [G, G_dir] = build_boundary(G, G_dir, n_sides);
    
    G.Nodes.Name = strtrim(node_names);
    G_dir.Nodes.Name = strtrim(node_names);
end

