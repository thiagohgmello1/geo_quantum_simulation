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
    [~, polygon_plot] = read_geometry('inputs/rectangle4.svg', gen.scale, mat.geometry_angle, false);
    [G, G_dir] = set_quantum_geometry(polygon_plot, mat.n_sides, mat.a, [2, 2] * 1e-10, 'angle', mat.angle);
    [geometry, polygon] = create_geometry(G);
end

%% input parameters

if TEST
    load('tests/rectangle_rho_performance.mat');
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
H = build_H(G_complete, mat, channel_id);
G_channel = G_nodes_by_id(G_complete, channel_id);

V_prev = sparse(zeros(numnodes(G_channel)));
rho = sparse(zeros(numnodes(G_channel)));
while iter.V_diff > iter.conv.U_tol && iter.counter <= iter.conv.max_iter
    V_results = poisson_solver(model, gen, Vol, G, mat.a, real(diag(rho)));
    V = calc_V(G_channel, V_results);
    iter.V_diff = max(max(abs(V - V_prev)));
    V_prev = V;
    rho = quantum_solver(G_complete, H, mat, iter, gen, num, V_results, mu, system);
    iter.counter = iter.counter + 1;
    disp(iter.counter);
end

%% Remove additional paths

delete(parallel_pool);
change_paths('folder_paths.txt', 2);











