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
%     [G, G_dir] = set_quantum_geometry(polygon_plot, mat.n_sides, mat.a, [5, 5] * 1e-9, 'angle', mat.angle);
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

[mu, gen, mat, iter] = set_params(system, gen, mat, iter);
Vol = mat.a_cc^2 * mat.t_G;

%% Create contacts
[G_contacts, ~] = create_contacts(G, mat, system);

%% Attach contacts to channel
G_complete = attach_contacts(G_contacts, G, mat.a, polygon_plot);

%% Quantum parameters
H = build_H(G_complete, mat, channel_id);

method = 1;

while iter.V_diff > iter.conv.U_tol && iter.counter < iter.conv.max_iter
    % Change gamma calculation for contacts and conductance
    [rho, Gamma, Sigma, Green, A, V_prev] = quantum_solver(G_complete, H, mat, iter, gen, results, mu, system, Vol, method);
    results = poisson_solver(model, gen.e_0, G, mat.a, real(diag(rho)));
%     V_diff = norm(V - V_prev) / norm(V + V_prev);
    V = calc_V(G_nodes_by_id(G_complete, channel_id), results);
    iter.counter = iter.counter + 1;
end

%% Remove additional paths

change_paths('folder_paths.txt', 2);










