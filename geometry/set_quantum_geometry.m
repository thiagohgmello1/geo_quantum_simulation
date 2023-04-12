function [G, dir_G] = set_quantum_geometry(polygon, n_sides, a, first_center, varargin)
%set_quantum_geometry Set quantum parameters as material geometry and fill
%region with these structures

    defaultRegisCenters = [];
    defaultAngle = 90;
    defaultIdOffset = 0;
    defaultCenterIdOffset = 0;
    p = inputParser;
    validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
    addRequired(p, 'polygon');
    addRequired(p, 'n_sides', validScalarPosNum);
    addRequired(p, 'a', validScalarPosNum);
    addRequired(p, 'first_center');
    addOptional(p, 'regis_centers', defaultRegisCenters);
    addOptional(p, 'angle', defaultAngle);
    addOptional(p, 'id_offset', defaultIdOffset);
    addOptional(p, 'center_id_offset', defaultCenterIdOffset);
    parse(p, polygon, n_sides, a, first_center, varargin{:});

    angle = p.Results.angle;
    regis_centers = p.Results.regis_centers;
    id_offset = p.Results.id_offset;
    center_id_offset = p.Results.center_id_offset;

    [polys_struct] = fill_region(polygon, n_sides, a, first_center, angle, regis_centers);
    [nodes, polys_struct] = create_nodes(polys_struct, 'center_id_offset', center_id_offset);
    nodes = def_boundary_nodes(nodes, polys_struct);
    nodes = reorder_nodes(nodes);
    [G, dir_G] = create_graph(nodes, n_sides, id_offset);
end