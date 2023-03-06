function [G, dir_G] = build_boundary(G, dir_G, n_sides)
%build_boundary build boundary for specific geometry
    
    non_boundary_color = [0, 0, 1];
    polys_G = allcycles(G,'MaxCycleLength',n_sides);
    n_polygons = length(polys_G);
    for idx=1:n_polygons
        poly_nodes = cell2mat(polys_G(idx));
        all_bounds = all(G.Nodes(poly_nodes,:).bounds);
        if all_bounds
            all_bounds_status = [];
            for j=1:length(poly_nodes)
                node = poly_nodes(j);
                neighs = neighbors(G, node);
                all_bounds_status = [all_bounds_status, all(G.Nodes(neighs,:).bounds)];
            end
            G.Nodes(poly_nodes(~all_bounds_status),:).bounds = false;
            G.Nodes(poly_nodes(~all_bounds_status),:).color = non_boundary_color;
        end
    end
end

