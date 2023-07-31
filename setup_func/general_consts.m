function gen = general_consts()
    gen = struct();
    gen.e_0 = 1 / (36 * pi * 1e9);
    gen.q = 1.60217663 * 1e-19; % electron charge in C
    gen.scale = 1e-9;
    gen.c = 3 * 1e8; % Speed of light in m/s
    gen.h = 4.135667696e-15; % Planck constant in eV*s
    gen.hbar = gen.h / (2 * pi); % Reduced Planck constant in eV*s
    gen.eq_fermi_energy = 0;
    gen.kB = 8.6173324 * 1e-5; % Boltzmann constant in eV/K
    gen.channel_id = 0;
end