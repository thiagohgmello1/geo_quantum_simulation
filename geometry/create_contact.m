function [nodes, polys_plot] = create_contact(G, dir_bound, n_sides, a, counter_offset)
%create_contact Create contact according boundary equation

    new_centers = [];
    theta = (n_sides - 2) * pi / (2 * n_sides);
    for node=dir_bound.nodes
        p0 = G.Nodes(node,:).coord;
        neig = neighbors(G, node);
        neig = intersect(neig, dir_bound.nodes);
        for neig_node=neig
            p1 = G.Nodes(neig_node,:).coord;
            center = G.Nodes(neig_node,:).center;
            new_centers = [new_centers; create_centers(p0, p1, G, center, theta, a)];
        end
    end
    is_unique = unique_tol(new_centers, 'radius_tol', 1e-10);
    new_centers = new_centers(is_unique,:);
    
    id_counter = 1 + counter_offset;
    [polys, polys_plot] = create_polys(new_centers, dir_bound.params.lead_eq, id_counter, n_sides, a);
    [nodes, ~] = create_nodes(polys, 'counter', id_counter);
    is_unique_node = unique_tol(vertcat(nodes.coord), 'radius_tol', 1e-10);
    nodes = nodes(is_unique_node);
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


function [polys, polys_plot] = create_polys(new_centers, func, id_counter, n_sides, a)
    polys = [];
    polys_plot = [];
    for i=1:length(new_centers)
        [pol, pol_plot] = create_poly(id_counter, n_sides, new_centers(i,:), a, 90);
        pol_tab = table(pol.vertices(:,1), pol.vertices(:,2));
        if all(rowfun(func, pol_tab).(1))
            polys = [polys pol];
            polys_plot = [polys_plot pol_plot];
            id_counter  = id_counter + 1;
        end
    end
end










