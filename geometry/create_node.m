function node = create_node(coordinates, id, is_bound, center)
%create_node create nodes from polygon edges

    node = {};
    node.id = id;
    node.coord = round(coordinates,4,"significant");
    node.neighbors = [];
    node.is_bound = is_bound;
    node.color = [0, 0, 1];
    node.center = center';
end

