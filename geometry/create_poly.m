function [pol, polygon] = create_poly(id, n_sides, center, side_len, angle)
%create_pol create polygon struct
    
    if nargin < 5
        angle = 0;
    end
    polygon = nsidedpoly(n_sides, 'Center', center, 'SideLength', side_len);
    polygon = rotate(polygon, angle, center);
    vertices = polygon.Vertices;
    
    pol = {};
    pol.id = id;
    pol.len = side_len;
    pol.n_sides = n_sides;
    pol.center = center';
    pol.vertices = vertices;
    pol.nodes = [];
    pol.is_bound = true;
%     pol.neig = [];
end

