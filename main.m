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
    [G, G_dir] = set_quantum_geometry(polygon_plot, n_sides, a, [2, 2] * 1e-10);
%     plot_graph(G, true);
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

[mat_props, converg_props, mu, energy_range] = set_params(system, eq_fermi_energy, energy_points, kB);
% [a, n_sides, t, epsilon, temp] = mat_props{:};
[t, epsilon, temp] = mat_props{:};
[eta, stop_cond, U_tol, max_iter] = converg_props{:};
[energy_1, energy_n, energy_points, delta_energy, energy_vec] = energy_range{:};
Vol = a_cc^2 * t_G;

%% Create contacts
[G_contacts, G_contacts_dir] = create_contacts(G, n_sides, system, a, graphene_angle);

%% Attach contacts to channel
G_complete = attach_contacts(G_contacts, G, a);

% [G_concat] = concat_graphs(G_contacts_dir);
% % Define periodic contact structures (included in quantum_solver)
% [alpha, beta, tau] = def_periodic_structures(G_complete, contact_trans_dir, a, epsilon, t);

%% Quantum parameters
H = build_H(G_complete, epsilon, t, channel_id);

method = 0;

V_test = calc_V(G_nodes_by_id(G_complete, channel_id), results);
while V_diff > U_tol && iter_counter < max_iter
    % Change gamma calculation for contacts and conductance
    [rho, Gamma, Sigma, Sigma_in, Green_r, Green_n, Green_a, A, V_prev] = ...
    quantum_solver(G_complete, H, results, energy_vec, delta_energy, mu, ...
                   temp, epsilon, t, eta, stop_cond, a, system, kB, Vol, method);

    results = poisson_solver(model, e_0, G, a, q * real(diag(rho)));
%     V_diff = norm(V - V_prev) / norm(V + V_prev);
    V = calc_V(G_nodes_by_id(G_complete, channel_id), results);
    iter_counter = iter_counter + 1
end

%% Remove additional paths

change_paths('folder_paths.txt', 2);










