function nodes = get_nodes(map_edges, edges)
%get_nodes Select nodes inside ROI region

    nodes = [];
    for edge=str2num(edges)
        nodes = [nodes map_edges{edge}];
    end
    nodes = unique(nodes);
end