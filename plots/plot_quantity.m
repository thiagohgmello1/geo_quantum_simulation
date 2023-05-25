function plot_quantity(G, quantity, varargin)
%plot_quantity plot any system quantity (quantity must have the size (n, 1)
%with n equal the number of nodes of G)
    
    defaultSize = 25;
    defaultId = 0;

    p = inputParser;
    validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x >= 0);
    addRequired(p, 'G');
    addRequired(p, 'quantity');
    addOptional(p, 'size', defaultSize, validScalarPosNum);
    addOptional(p, 'region_id', defaultId, validScalarPosNum);
    parse(p, G, quantity, varargin{:});
    size = p.Results.size;
    region_id = p.Results.region_id;
    
    G = G_nodes_by_id(G, region_id);
    pos = G.Nodes.coord;
    x = pos(:,1);
    y = pos(:,2);
    scatter(x, y, size, quantity, 'filled');
end