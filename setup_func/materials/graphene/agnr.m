function mat = agnr()
    % Armchair graphene

    mat = struct();
    mat.a = 1.42e-10; % Lattice side
    mat.a_cc = 2.46e-10; % Lattice constant
    mat.t_G = 3.4e-10; % Graphene thickness (for monolayer)
    mat.angle = 0;
    mat.n_sides = 6;
    mat.geometry_angle = 0;
    mat.sublattice_size = 2;
end
