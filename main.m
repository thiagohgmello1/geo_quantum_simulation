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
energy_points = 100;

% Material properties
graphene_angle = 90;
n_sides = 6;

% Convergency parameters
geometry_angle = 0;

%% Graph generation

if ~TEST
    [~, polygon_plot] = read_geometry('inputs/diode5.svg', scale, geometry_angle, false);
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
    system = Boundaries(model, geometry, G);
    results = poisson_solver(model);
    figure;
    pdeplot(model,'XYData',results.NodalSolution);
    % pdeplot(model,"XYData",results.NodalSolution,"ZData",results.NodalSolution, 'Mesh', 'on')
    % grid();
end

[mat_props, converg_props, ec_pots, energy_range] = set_params(system, eq_fermi_energy, energy_points, kB);
% [a, n_sides, t, epsilon, temp] = mat_props{:};
[t, epsilon, temp] = mat_props{:};
[eta, stop_cond, U_tol, max_iter] = converg_props{:};
[mu_left, mu_right] = ec_pots{:};
[energy_1, energy_n, energy_points, delta_energy, energy_vec] = energy_range{:};

%% Create contacts
G_contacts = create_contacts(G, n_sides, system, a, graphene_angle);

%% Attach contacts to channel
G_contact = attach_contacts(G_contacts, G, a);

%% Define periodic contact structures
for dir_bound=system.boundaries.dir
    [alpha, beta, tau] = def_periodic_structures(G_contact, dir_bound.nodes, n_sides);
end

%% Quantum parameters
H = build_H(dir_G, epsilon, t);
iter_counter = 1;
V_diff = inf;
V_prev = 0;

while V_diff > U_tol && iter_counter < max_iter
    [rho, Gamma_left, Gamma_right, Green_r, Green_n, Green_a, A, V] = ...
    quantum_solver(G, H, results, energy_vec, delta_energy, mu_left,...
    mu_right, temp, epsilon, t, eta, stop_cond, system, G_contact);

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










