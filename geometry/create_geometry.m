function [geometry, geometry_vec] = create_geometry(G)
%create_geometry create a matrix to build PDE tool geometry

    H = subgraph(G, G.Nodes(table2array(G.Nodes(:,1)),:).Name);
    cycles = allcycles(H);
    bound_coords = G.Nodes(str2num(cell2mat(cycles{1,1}')),:).coord;
    x = bound_coords(:,1);
    y = bound_coords(:,2);
    geometry_vec = [x, y];
    polygons = [2; length(bound_coords)];
    polygons = [polygons; x; y];
    geometry = decsg(polygons);
end