function [pol, polygon] = create_poly(id, n_sides, center, side_len, varargin)
%create_pol create polygon struct

    defaultAngle = 0;
    p = inputParser;
    validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
    addRequired(p,'id', validScalarPosNum);
    addRequired(p,'n_sides', validScalarPosNum);
    addRequired(p,'center');
    addRequired(p,'side_len', validScalarPosNum);
    addOptional(p, 'angle', defaultAngle);
    parse(p, id, n_sides, center, side_len, varargin{:});

    polygon = nsidedpoly(n_sides, 'Center', center, 'SideLength', side_len);
    polygon = rotate(polygon, p.Results.angle, center);
    vertices = polygon.Vertices;
    
    pol = {};
    pol.id = id;
    pol.len = side_len;
    pol.n_sides = n_sides;
    pol.center = center';
    pol.vertices = vertices;
    pol.nodes = [];
    pol.is_bound = true;
end

