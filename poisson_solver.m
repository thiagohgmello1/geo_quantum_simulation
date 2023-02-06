%%
clear all;
close all;
clc;

addpath(genpath('svg_reader'), genpath('basic_gui'), genpath('setup_func'));

scale = 1e-9;
model = createpde(1);
geometry = read_geometry('example2.svg', scale, false);
geometryFromEdges(model,geometry);
geometry_model = Boundaries(geometry);
apply_bounds(model, geometry_model.boundaries);
apply_params(model, geometry_model.params);
geometry_model.mesh = Mesh_params(model, geometry_model, @apply_mesh);
results = solvepde(model);
pdeplot(model,'XYData',results.NodalSolution);

rmpath('svg_reader');
rmpath('basic_gui');
rmpath('setup_func');












