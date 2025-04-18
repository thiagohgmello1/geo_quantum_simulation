function gen = general_consts()
% Create general constants

    gen = struct();
    gen.e_0 = 1 / (36 * pi * 1e9);  % Vaccum permittivity
    gen.q = 1.60217663 * 1e-19;     % Electron charge in C
    gen.scale = 1e-9;               % Geometry scale
    gen.c = 2.99792458 * 1e8;       % Speed of light in m/s
    gen.h = 4.135667696e-15;        % Planck constant in eV*s
    gen.hbar = gen.h / (2 * pi);    % Reduced Planck constant in eV*s
    gen.eq_fermi_energy = 0;        % Equilibrium fermi energy
    gen.kB = 8.6173324 * 1e-5;      % Boltzmann constant in eV/K
    gen.channel_id = 0;             % Selected channel id (0 is recommended)
    gen.from_id = 1;                % Input terminal index
    gen.to_id = 2;                  % Output terminal index
    gen.temp = 300;                 % Temperature in K
    gen.chemical_pot = [-9, 9];     % Terminals chemical potential [eV]
    gen.V_gate = 0;                 % Gate voltage
end