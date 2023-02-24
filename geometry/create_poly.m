function [pol, polygon] = create_poly(id, n_sides, center, side_len)
%create_pol create polygon struct
    

    polygon = nsidedpoly(n_sides, 'Center', center, 'SideLength', side_len);
    vertices = polygon.Vertices;
    
    pol = {};
    pol.id = id;
    pol.len = side_len;
    pol.n_sides = n_sides;
    pol.center = center';
    pol.vertices = vertices;
    pol.nodes = [];
end

