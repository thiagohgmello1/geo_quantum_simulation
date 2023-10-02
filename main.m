%% Set parameters

clear;
% close all;
clc;
if isempty(gcp('nocreate'))
    myCluster = parcluster('local');
    parallel_pool = parpool("Processes", myCluster.NumWorkers - 1);
end


TEST = false;

change_paths('folder_paths.txt', 1);

% Load constants
constants;

%% Graph generation

if ~TEST
    [~, polygon_plot] = read_geometry('inputs/test.svg', gen.scale, mat.geometry_angle, false);
    [G, G_dir] = set_quantum_geometry(polygon_plot, mat.n_sides, mat.a, [1, 1] * 1e-9, 'angle', mat.angle);
    [geometry, polygon] = create_geometry(G);
end

%% input parameters

if TEST
    load('tests/rectangle_kwant.mat');
else
    model = createpde(1);
    geometryFromEdges(model, geometry);
    system = Boundaries(model, geometry, G);
end

%% Load parameters
[mu, gen, mat, iter] = set_params(system, gen, mat, iter, num);
Vol = mat.a_cc^2;

%% Create contacts
[G_contacts, ~] = create_contacts(G, mat, system);

%% Attach contacts to channel
G_complete = attach_contacts(G_contacts, G, mat.a, polygon_plot);

%% Quantum parameters
from_id = 1;
to_id = 2;
tic;
[I, V] = calc_IV_curve(G_complete, system, channel_id, mat, iter, num, mu, gen, from_id, to_id);
toc;
%% Remove additional paths

delete(parallel_pool);
change_paths('folder_paths.txt', 2);











