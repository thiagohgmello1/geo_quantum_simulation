function map_edge_node = map_edges(G, geometry)
%map_edges Map each edge to respective nodes
    
    map_edge_node = {};
    neig = neighbors(G, 1);
    a = norm(G.Nodes.coord(1,:) - G.Nodes.coord(neig(1),:));
    pos = G.Nodes.coord(G.Nodes.bounds,:);
    names = G.Nodes.Name(G.Nodes.bounds,:);
    edges_len = size(geometry, 2);
    for i=1:edges_len
        nodes = [];
        for j=2:3
            x = geometry(j, i);
            y = geometry(j + 2, i);
            node = str2double(cell2mat(names(all(is_close([x y], pos), 2))));
            nodes = [nodes node];
        end
        map_edge_node{i} = nodes;
    end
end