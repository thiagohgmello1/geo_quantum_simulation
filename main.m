%% Set parameters

clear;
% close all;
clc;

addpath(genpath('svg_reader'), genpath('basic_gui'), genpath('setup_func'),...
    genpath('geometry'), genpath('NEGF_functions'), genpath('solvers'));

TEST = false;

% Constants
a = 1.42e-10;
e_0 = 1 / (36 * pi * 1e9);
q = -1.60217663 * 1e-19;
scale = 1e-9;
eq_fermi_energy = 0.1;
kB = 8.6173324 * 1e-5; % Boltzmann constant in eV/K

% Material properties
n_sides = 6;

% Convergency parameters
geometry_angle = 0;

%% Graph generation

if ~TEST
    [geometry_plot, polygon_plot] = read_geometry('inputs/diode5.svg', scale, geometry_angle, false);
    [G, dir_G] = set_quantum_geometry(polygon_plot, n_sides, a, [2e-1, 2e-1] * 1e-9);
%     [G, dir_G] = set_quantum_geometry(polygon_plot, n_sides, a);
    plot_graph(G, true);
    [geometry, polygon] = create_geometry(G);
end

%% input parameters

if TEST
    load('tests/rectangle_sol.mat');
else
    model = createpde(1);
    geometryFromEdges(model, geometry);
    bounds = Boundaries(model, geometry);
    results = poisson_solver(model);
    figure;
    pdeplot(model,'XYData',results.NodalSolution);
    % pdeplot(model,"XYData",results.NodalSolution,"ZData",results.NodalSolution, 'Mesh', 'on')
    % grid();
end

% Material properties
a = bounds.mat_props.lattice_len;
t = bounds.mat_props.hoppings;
epsilon = bounds.mat_props.onsite;
temp = bounds.mat_props.temp;
n_sides = bounds.mat_props.n_sides;

% Convergency properties
eta = bounds.conv_params.eta;
stop_cond = bounds.conv_params.self_e_conv;
U_tol = bounds.conv_params.delta_U;
max_iter = bounds.conv_params.max_iter;

mu_left = eq_fermi_energy + 1/2;
mu_right = eq_fermi_energy - 1/2;

% Energy range
energy_1 = mu_right - 4 * kB * temp;
energy_n = mu_left + 4 * kB * temp;
energy_points = 100;
delta_energy = (energy_n - energy_1) / energy_points;
energy_vec = t * linspace(energy_1, energy_n, energy_points);

%% Quantum parameters
H = build_H(dir_G, epsilon, t);
iter_counter = 1;
V_diff = inf;
V_prev = 0;

while V_diff > U_tol && iter_counter < max_iter
    [rho, Gamma_left, Gamma_right, Green_r, Green_n, Green_a, A, V] = ...
    quantum_solver(G, H, results, energy_vec, delta_energy, mu_left,...
    mu_right, temp, epsilon, t, eta, stop_cond, bounds);

    results = poisson_solver(model, e_0, G, a, real(diag(rho)));

%     V_diff = norm(V - V_prev) / norm(V + V_prev);
    V_prev = V;
    iter_counter = iter_counter + 1;
end



%%

rmpath('svg_reader');
rmpath('basic_gui');
rmpath('setup_func');
rmpath('geometry');
rmpath('NEGF_functions');
rmpath('solvers');

%% Plot scatter
pos = G.Nodes.coord;
x = pos(:,1);
y=pos(:,2);
scatter(x,y,25,abs(rho),'filled');










