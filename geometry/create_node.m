function node = create_node(coordinates, id)
%create_node create nodes from polygon edges

    node = {};
    node.id = id;
    node.coord = coordinates;
    node.neighbors = [];
end

