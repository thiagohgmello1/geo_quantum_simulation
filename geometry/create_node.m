function node = create_node(coordinates, id, is_bound)
%create_node create nodes from polygon edges

    node = {};
    node.id = id;
    node.coord = round(coordinates,4,"significant");
    node.neighbors = [];
    node.is_bound = is_bound;
    node.color = [0, 0, 1];
end

