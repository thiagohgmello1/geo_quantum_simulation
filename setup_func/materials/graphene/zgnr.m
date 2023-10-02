function mat = zgnr()
    % Zigzag graphene
    
    mat = struct();
    mat.a = 1.42e-10; % Lattice side
    mat.a_cc = 2.46e-10; % Lattice constant
    mat.t_G = 3.4e-10; % Graphene thickness (for monolayer)
    mat.angle = 90;
    mat.n_sides = 6;
    mat.geometry_angle = 0;
    mat.sublattice_size = 2;
    mat.t = -2.8;
    mat.epsilon = 0;
    mat.coulomb = 1; % Simulation (1) or not (0) of Coulomb approximation
end