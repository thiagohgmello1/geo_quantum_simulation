function [G, dir_G] = set_quantum_geometry(polygon, n_sides, a, first_center, varargin)
%set_quantum_geometry Set quantum parameters as material geometry and fill
%region with these structures

    defaultRegisCenters = [];
    defaultAngle = 90;
    defaultCounter = 1;
    p = inputParser;
    validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
    addRequired(p, 'polygon');
    addRequired(p, 'n_sides', validScalarPosNum);
    addRequired(p, 'a', validScalarPosNum);
    addRequired(p, 'first_center');
    addOptional(p, 'regis_centers', defaultRegisCenters);
    addOptional(p, 'angle', defaultAngle);
    addOptional(p, 'counter_id', defaultCounter, validScalarPosNum);
    parse(p, polygon, n_sides, a, first_center, varargin{:});

    angle = p.Results.angle;
    regis_centers = p.Results.regis_centers;

    [polys_struct] = fill_region(polygon, n_sides, a, first_center, angle, regis_centers);
    [nodes, polys_struct] = create_nodes(polys_struct);
    nodes = def_boundary_nodes(nodes, polys_struct);
    nodes = reorder_nodes(nodes);
    [G, dir_G] = create_graph(nodes, n_sides);
end