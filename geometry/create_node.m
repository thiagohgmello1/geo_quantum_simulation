function node = create_node(coordinates, id)
%create_node create nodes from polygon edges

    node = {};
    node.id = id;
    node.coord = round(coordinates,4,"significant");
    node.neighbors = [];
end

