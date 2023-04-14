function H = create_subregions(G, region_id)
%create_subgraphs Create subgraph according desired region id

    reg_qty = length(region_id);
    H = cell(reg_qty, 1);
    for i=1:reg_qty
        H{i} = subgraph(G, find(G.Nodes.contact_id == region_id(i)));
    end
    if length(H) == 1
        H = H{1};
    end
end