%% Poisson solver
clear all;
close all;
clc;

addpath(genpath('svg_reader'), genpath('basic_gui'), genpath('setup_func'), genpath('geometry'));

scale = 1e-9;
model = createpde(1);
[geometry, polygon] = read_geometry('diode3.svg', scale, false);
geometryFromEdges(model,geometry);
geometry_model = Boundaries(geometry);
apply_bounds(model, geometry_model.boundaries);
apply_params(model, geometry_model.params);
geometry_model.mesh = Mesh_params(model, geometry_model, @apply_mesh);
results = solvepde(model);
figure;
pdeplot(model,'XYData',results.NodalSolution);

%% Graph generation
graphene_angle = 45;
[polys_struct, polys, boundary] = fill_region(polygon, 6, 0.3 * 1e-9, [0.8, 0.6] * 1e-8, graphene_angle);
[nodes, polys_struct] = create_nodes(polys_struct);
nodes = reorder_nodes(nodes);
[G, dir_G] = create_graph(nodes);

% plot_geometry(polygon, polys, polys_struct, nodes, true, false);
plot_graph(G, true);

%%

rmpath('svg_reader');
rmpath('basic_gui');
rmpath('setup_func');
rmpath('geometry');












