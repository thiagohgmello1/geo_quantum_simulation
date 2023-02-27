[polys_struct, polys, boundary] = fill_region(polygon, 6, 0.3 * 1e-9, [0.8, 0.6] * 1e-8);
[nodes, polys_struct] = create_nodes(polys_struct);
G = create_graph(nodes);

plot_geometry(polygon, polys, polys_struct, nodes, true, false);