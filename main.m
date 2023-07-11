%% Set parameters

clear;
% close all;
clc;

change_paths('folder_paths.txt', 1);

TEST = true;

% Load constants
constants;

%% Graph generation

if ~TEST
    [~, polygon_plot] = read_geometry('inputs/rectangle1.svg', gen.scale, mat.geometry_angle, false);
    [G, G_dir] = set_quantum_geometry(polygon_plot, mat.n_sides, mat.a, [2, 2] * 1e-10, 'angle', mat.angle);
    [geometry, polygon] = create_geometry(G);
end

%% input parameters

if TEST
    load('tests/rectangle_default.mat');
else
    model = createpde(1);
    geometryFromEdges(model, geometry);
    system = Boundaries(model, geometry, G);
    results = poisson_solver(model);
    figure;
    pdeplot(model,'XYData',results.NodalSolution);
end

[mat_props, converg_props, mu, energy_range] = set_params(system, eq_fermi_energy, energy_points, kB);
% [a, n_sides, t, epsilon, temp] = mat_props{:};
[t, epsilon, temp] = mat_props{:};
[eta, stop_cond, U_tol, max_iter] = converg_props{:};
[energy_1, energy_n, energy_points, delta_energy, energy_vec] = energy_range{:};
Vol = a_cc^2 * t_G;

%% Create contacts
[G_contacts, ~] = create_contacts(G, n_sides, system, a, graphene_angle);

%% Attach contacts to channel
G_complete = attach_contacts(G_contacts, G, a, polygon_plot);

%% Quantum parameters
H = build_H(G_complete, epsilon, t, channel_id);

method = 0;

V_test = calc_V(G_nodes_by_id(G_complete, channel_id), results);
while V_diff > U_tol && iter_counter < max_iter
    % Change gamma calculation for contacts and conductance
    [rho, Gamma, Sigma, Green, A, V_prev] = ...
    quantum_solver(G_complete, H, results, energy_vec, delta_energy, mu, ...
                   temp, epsilon, t, eta, stop_cond, a, system, kB, Vol, method);

    results = poisson_solver(model, e_0, G, a, q * real(diag(rho)));
%     V_diff = norm(V - V_prev) / norm(V + V_prev);
    V = calc_V(G_nodes_by_id(G_complete, channel_id), results);
    iter_counter = iter_counter + 1
end

%% Remove additional paths

change_paths('folder_paths.txt', 2);










