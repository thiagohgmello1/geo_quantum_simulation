function mat = zgnr()
    % Zigzag graphene
    
    mat = struct();
    mat.a = 1.42e-10;        % Lattice side
    mat.n_sides = 6;         % Elementary polygon (6 = hexagon, 4 = square and so on)
    mat.angle = 90;          % Elementary rotation polygon angle (in degree)
    mat.geometry_angle = 0;  % Geometry rotation angle (in degree)
    mat.t = -2.8;            % Material hopping energy
    mat.epsilon = 4;         % Material onsite energy
    mat.coulomb = 0;         % Simulation of Coulomb approximation (1 -> simulate, 0 -> not simulate)
end