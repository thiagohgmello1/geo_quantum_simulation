function [G_contact, G_contact_dir] = create_contact(G, dir_bound, n_sides, a, varargin)
%create_contact Create contact according boundary equation
    
    defaultAngle = 0;
    defaultIdOffset  = 1;
    defaultCenterIdOffset = 0;
    p = inputParser;
    validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
    addRequired(p,'G');
    addRequired(p,'dir_bound');
    addRequired(p,'n_sides', validScalarPosNum);
    addRequired(p,'a');
    addOptional(p, 'angle', defaultAngle);
    addOptional(p, 'id_offset', defaultIdOffset);
    addOptional(p, 'center_id_offset', defaultCenterIdOffset);
    parse(p, G, dir_bound, n_sides, a, varargin{:});

    angle = p.Results.angle;
    new_centers = [];
    id_offset = p.Results.id_offset;
    center_id_offset = p.Results.center_id_offset;

    theta = (n_sides - 2) * pi / (2 * n_sides);
    for node=dir_bound.nodes
        pos = findnode(G, string(node));
        p0 = G.Nodes(pos,:).coord;
        neig = neighbors(G, pos);
        neig = intersect(neig, dir_bound.nodes);
        for neig_node=neig
            p1 = G.Nodes(neig_node,:).coord;
            center = G.Nodes(neig_node,:).center;
            new_centers = [new_centers; create_centers(p0, p1, G, center, theta, a)];
        end
    end
    is_unique = unique_tol(new_centers, 'radius_tol', a / 2);
    new_centers = new_centers(is_unique,:);
    center_counter = 1;

    [first_poly, ~] = create_poly(1, n_sides, new_centers(center_counter,:), a, 'angle', angle);
    while ~is_inside(first_poly.vertices, dir_bound.params.lead_eq) && (length(new_centers) > center_counter)
        center_counter  = center_counter + 1;
        [first_poly, ~] = create_poly(1, n_sides, new_centers(center_counter,:), a, 'angle', angle);
    end
    regis_centers = unique_tol(G.Nodes.center, 'radius_tol', a / 2);
    regis_centers = G.Nodes.center(regis_centers,:);
    [G_contact, G_contact_dir] = set_quantum_geometry(dir_bound.params.lead_eq, n_sides,...
        a, first_poly.center', regis_centers, angle, id_offset, center_id_offset, dir_bound.params.trans_dir);
end


function centers = create_centers(p0, p1, G, center, theta, a)
    vec = p0 - p1;
    unit_vec = vec / a;
    apotema = a / 2 * tan(theta);
    centers = [center + 2 * apotema * rotate_vec(unit_vec', 90)'; ...
        center + 2 * apotema * rotate_vec(unit_vec', -90)'];
    centers = centers(check_centers(centers, G, a),:);
end


function new_center = check_centers(centers, G, a)
    new_center = [];
    registered_centers = G.Nodes.center;
    for i=1:length(centers)
        if all(~all(is_close(centers(i,:), registered_centers, 'rtol', 0, 'atol', a), 2))
            new_center = [new_center false];
        else
            new_center = [new_center true];
        end
    end
    new_center = ~new_center;
end









