function nodes = reorder_nodes(nodes)
%reorder_nodes reorder nodes according physical positions

    nodes_coords = vertcat(nodes.coord);
    [~, idx] = sortrows(nodes_coords,[1 2]);
    
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

