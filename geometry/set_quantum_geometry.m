function [G, dir_G] = set_quantum_geometry(polygon, n_sides, a, initial_pos)
%set_quantum_geometry Set quantum parameters as material geometry and fill
%region with these structures

    if nargin < 4
        initial_pos = set_initial_pos(polygon, n_sides, a);
    end
    angle = 0;
    [polys_struct, ~] = fill_region(polygon, n_sides, a, initial_pos, angle);
    [nodes, ~] = create_nodes(polys_struct);
    nodes = reorder_nodes(nodes);
    [G, dir_G] = create_graph(nodes);
end