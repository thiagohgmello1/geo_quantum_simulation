%% Set parameters

clear all;
close all;
clc;

addpath(genpath('svg_reader'), genpath('basic_gui'), genpath('setup_func'),...
    genpath('geometry'), genpath('NEGF_functions'));

a = 0.142 * 1e-9;
epsilon = 0;
t = -2.7;
temp = 300;
mu_left = 1;
mu_right = 1;
energy = 0;
eta = 1e-3;
stop_cond = 1e-4;
graphene_angle = 0;
n_sides = 6;


%% Poisson solver

geometry_angle = 0;
scale = 1e-9;
model = createpde(1);
[geometry, polygon] = read_geometry('diode4.svg', scale, geometry_angle, false);
geometryFromEdges(model,geometry);
geometry_model = Boundaries(geometry);
apply_bounds(model, geometry_model.boundaries);
apply_params(model, geometry_model.params);
geometry_model.mesh = Mesh_params(model, geometry_model, @apply_mesh);
results = solvepde(model);
figure;
pdeplot(model,'XYData',results.NodalSolution);
% pdeplot(model,"XYData",results.NodalSolution,"ZData",results.NodalSolution, 'Mesh', 'on')

%% Graph generation

fermi_left = fermi_level(energy, mu_left, temp);
fermi_right = fermi_level(energy, mu_right, temp);

[G, dir_G] = set_quantum_geometry(polygon, n_sides, a);

n_atoms = numnodes(G);
U = zeros(n_atoms);

[H, Green_r, Green_a, Green_n, A, Gamma_left, Gamma_right, Sigma_left, Sigma_right, Sigma_in_left, Sigma_in_right] = ...
    build_NEGF(G, dir_G, U, epsilon, t, energy, eta, stop_cond, fermi_left, fermi_right);

% plot_geometry(polygon, polys, polys_struct, nodes, true, false);
plot_graph(G, true);

%%

rmpath('svg_reader');
rmpath('basic_gui');
rmpath('setup_func');
rmpath('geometry');
rmpath('NEGF_functions');











