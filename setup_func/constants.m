%% Constants

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
geometry_angle = 0;

% General channel ID
channel_id = 0;

% Quantum simulation initial parameters
iter_counter = 1;
V_diff = inf;
V_prev = 0;