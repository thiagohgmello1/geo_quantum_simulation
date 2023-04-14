%% Set parameters

clear;
% close all;
clc;

change_paths('folder_paths.txt', 1);

TEST = false;

% Load constants
constants;

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
    load('tests/rectangle_general.mat');
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
contact_trans_dir = [system.boundaries.dir.params];
contact_trans_dir = vertcat(contact_trans_dir.trans_dir);

[mat_props, converg_props, ec_pots, energy_range] = set_params(system, eq_fermi_energy, energy_points, kB);
% [a, n_sides, t, epsilon, temp] = mat_props{:};
[t, epsilon, temp] = mat_props{:};
[eta, stop_cond, U_tol, max_iter] = converg_props{:};
[mu_left, mu_right] = ec_pots{:};
[energy_1, energy_n, energy_points, delta_energy, energy_vec] = energy_range{:};

%% Create contacts
[G_contacts, G_contacts_dir] = create_contacts(G, n_sides, system, a, graphene_angle);

%% Attach contacts to channel
G_complete = attach_contacts(G_contacts, G, a);

%% Define periodic contact structures
[alpha, beta, tau] = def_periodic_structures(G_complete, contact_trans_dir, a);

%% Quantum parameters
H = build_H(dir_G, epsilon, t);
iter_counter = 1;
V_diff = inf;
V_prev = 0;

while V_diff > U_tol && iter_counter < max_iter
    [rho, Gamma_left, Gamma_right, Green_r, Green_n, Green_a, A, V] = ...
    quantum_solver(G, H, results, energy_vec, delta_energy, mu_left,...
    mu_right, temp, epsilon, t, eta, stop_cond, system, G_complete);

    results = poisson_solver(model, e_0, G, a, real(diag(rho)));

%     V_diff = norm(V - V_prev) / norm(V + V_prev);
    V_prev = V;
    iter_counter = iter_counter + 1;
end

%% Remove additional paths

change_paths('folder_paths.txt', 2);

%% Plot scatter
pos = G.Nodes.coord;
x = pos(:,1);
y=pos(:,2);
scatter(x,y,25,abs(rho),'filled');










