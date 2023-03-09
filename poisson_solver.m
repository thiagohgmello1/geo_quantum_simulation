%% Set parameters

clear;
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

geometry_angle = 0;
scale = 1e-9;

%% Graph generation

[geometry_plot, polygon_plot] = read_geometry('diode4.svg', scale, geometry_angle, false);
[G, dir_G] = set_quantum_geometry(polygon_plot, n_sides, a, [3, 2] * 1e-9);
plot_graph(G, true);
[geometry, polygon] = create_geometry(G);

%% Poisson solver

model = createpde(1);
geometryFromEdges(model, geometry);
Boundaries(model, geometry);
results = solvepde(model);
figure;
pdeplot(model,'XYData',results.NodalSolution);
% pdeplot(model,"XYData",results.NodalSolution,"ZData",results.NodalSolution, 'Mesh', 'on')

%% Quantum parameters

fermi_left = fermi_level(energy, mu_left, temp);
fermi_right = fermi_level(energy, mu_right, temp);

n_atoms = numnodes(G);
U = zeros(n_atoms);

[H, Green_r, Green_a, Green_n, A, Gamma_left, Gamma_right, Sigma_left, Sigma_right, Sigma_in_left, Sigma_in_right] = ...
    build_NEGF(G, dir_G, U, epsilon, t, energy, eta, stop_cond, fermi_left, fermi_right);

%%

rmpath('svg_reader');
rmpath('basic_gui');
rmpath('setup_func');
rmpath('geometry');
rmpath('NEGF_functions');











