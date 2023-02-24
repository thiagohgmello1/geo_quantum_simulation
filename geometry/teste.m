[hex_str, hex_poly, boundary] = fill_region(polygon, 6, 0.3 * 1e-9, [0.8, 0.6] * 1e-8);
[nodes, hex_str] = create_nodes(hex_str);

plot_geometry(polygon,hex_poly, hex_str, nodes, true, false)