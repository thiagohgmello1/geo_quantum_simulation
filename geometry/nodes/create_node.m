function node = create_node(coordinates, id, is_bound, center, center_id)
%create_node create nodes from polygon edges

    node = {};
    node.id = id;
    node.coord = coordinates;
    node.neighbors = [];
    node.is_bound = is_bound;
    node.color = [0, 0, 1];
    node.center = center';
    node.center_id = center_id;
end

