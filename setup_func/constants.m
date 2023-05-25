%% Constants

e_0 = 1 / (36 * pi * 1e9);
q = 1.60217663 * 1e-19; % electron charge in C
scale = 1e-9;
c = 3 * 1e8; % Speed of light in m/s
h = 4.135667696e-15; % Planck constant in eV*s
hbar = h / (2 * pi); % Reduced Planck constant in eV*s
eq_fermi_energy = 0;
kB = 8.6173324 * 1e-5; % Boltzmann constant in eV/K
energy_points = 100;

% Material properties
a = 1.42e-10; % Lattice side
a_cc = 2.46e-10; % Lattice constant
t_G = 3.4e-10; % Graphene thickness (for monolayer)
graphene_angle = 90;
n_sides = 6;
geometry_angle = 0;

% General channel ID
channel_id = 0;

% Quantum simulation initial parameters
iter_counter = 1;
V_diff = inf;
V_prev = 0;