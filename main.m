%% Set parameters

clear;
% close all;
clc;
if isempty(gcp('nocreate'))
    myCluster = parcluster('local');
    parallel_pool = parpool("Processes", myCluster.NumWorkers - 1);
end

change_paths('folder_paths.txt', 1);

% Load constants
constants;

%% Graph generation

[~, polygon_plot] = read_geometry('example/rectangle.svg', gen.scale, mat.geometry_angle, false);
[G, G_dir] = set_quantum_geometry(polygon_plot, mat.n_sides, mat.a, [0.2, 0.2] * 1e-9, 'angle', mat.angle);
[geometry, polygon] = create_geometry(G);

%% input parameters

model = createpde(1);
geometryFromEdges(model, geometry);
system = Boundaries(model, geometry, G);

%% Load parameters
[mu, gen, mat, iter] = set_params(system, gen, mat, iter, num);

%% Create contacts
[G_contacts, ~] = create_contacts(G, mat, system);

%% Attach contacts to channel
G_complete = attach_contacts(G_contacts, G, mat.a, polygon_plot);

%% Quantum parameters

tic;
[I, V, rho, H] = calc_IV_curve(G_complete, system, channel_id, mat, iter, num, mu, gen, model);
toc;
%% Remove additional paths

delete(parallel_pool);
change_paths('folder_paths.txt', 2);











