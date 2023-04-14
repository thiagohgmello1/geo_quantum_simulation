function nodes = reorder_nodes(nodes, varargin)
%reorder_nodes reorder nodes according physical positions
    
    defaultReorderDir = [1, 0];

    p = inputParser;
    addRequired(p, 'nodes');
    addOptional(p, 'reorder_dir', defaultReorderDir);
    parse(p, nodes, varargin{:});
    reorder_dir = p.Results.reorder_dir;
    
    if sign(reorder_dir(reorder_dir > 0)) > 0
        ordering = 'ascend';
    else
        ordering = 'descend';
    end

    dir = [1, 1] .* reorder_dir + [2, 2] .* (~reorder_dir);

    nodes_coords = vertcat(nodes.coord);
    [~, idx] = sortrows(nodes_coords, dir, {ordering 'ascend'});
    
    for node_id=1:length(nodes)
        node = nodes(node_id);
        node.id = find(idx == node_id);
        for neig_id=1:length(node.neighbors)
            old_neig = node.neighbors(neig_id);
            node.neighbors(neig_id) = find(idx == old_neig);
        end
        nodes(node_id) = node;
    end
    nodes_table = struct2table(nodes);
    sorted_table = sortrows(nodes_table, 'id');
    nodes = table2struct(sorted_table);
end

