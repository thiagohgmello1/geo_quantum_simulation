%% Set parameters

clear;
close all;
clc;

addpath(genpath('svg_reader'), genpath('basic_gui'), genpath('setup_func'),...
    genpath('geometry'), genpath('NEGF_functions'));

TEST = true;

% Constants
e_0 = 1 / (36 * pi * 1e9);
q = -1.60217663 * 1e-19;
scale = 1e-9;

% Graphene properties
a = 0.142 * 1e-9;
a_length = a;
thickness_g = 3.4e-10;
epsilon = 0;
t = -2.7;
temp = 300;
graphene_angle = 0;
n_sides = 6;
intrinsic_fermi = 2.53 * 1e-4 * temp;

% Energy range
energy_1 = -0.5;
energy_n = 0.5;
energy_points = 20;
delta_energy = (energy_n - energy_1) / energy_points;
energy_vec = linspace(energy_1, energy_n, energy_points);

% Convergency parameters
eta = 1e-3;
stop_cond = 1e-4;
U_tol = 1e-4;
max_iter = 10;
geometry_angle = 0;

%% Graph generation

if ~TEST
    [geometry_plot, polygon_plot] = read_geometry('diode4.svg', scale, geometry_angle, false);
    [G, dir_G] = set_quantum_geometry(polygon_plot, n_sides, a, [3, 2] * 1e-9);
    plot_graph(G, true);
    [geometry, polygon] = create_geometry(G);
end

%% Poisson solver

if TEST
    load('tests/diode4_sol.mat');
else
    model = createpde(1);
    geometryFromEdges(model, geometry);
    bounds = Boundaries(model, geometry);
    results = solvepde(model);
    figure;
    pdeplot(model,'XYData',results.NodalSolution);
end
mu_left = 0;
mu_right = -1;
% pdeplot(model,"XYData",results.NodalSolution,"ZData",results.NodalSolution, 'Mesh', 'on')
% grid();

%% Quantum parameters
H = build_H(dir_G, epsilon, t);
iter_counter = 1;
V_diff = inf;
V_prev = 0;
volume = a_length ^ 2 * thickness_g;
% volume = 3 * sqrt(3) * a ^ 2 / 2; 

while V_diff > U_tol && iter_counter < max_iter
    rho = zeros([size(H, 1), 1]);
    V = calc_V(G, results);
    U = -V - intrinsic_fermi * eye(size(V));
    
    for energy=energy_vec
        fermi_left = fermi_level(energy, mu_left, temp);
        fermi_right = fermi_level(energy, mu_right, temp);
    
        [Gamma_left, Gamma_right, Sigma_left, Sigma_right, Sigma_in_left, Sigma_in_right] = ...
            build_NEGF(G, epsilon, t, energy, eta, stop_cond, fermi_left, fermi_right);
        
        [Green_r, Green_n, Green_a, A] = build_greens_params(G, ...
            energy, eta, H, U, Sigma_right, Sigma_left, Sigma_in_left, Sigma_in_right);
        rho = rho + delta_energy * diag(Green_n) / (2 * pi * volume);
    end
    rho = q * rho;
    recursively_apply_params(-rho / e_0, G, model, a);
    results = solvepde(model);
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

%% Plot scatter
pos = G.Nodes.coord;
x = pos(:,1);
y=pos(:,2);
scatter(x,y,25,abs(rho),'filled');










