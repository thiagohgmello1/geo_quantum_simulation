function [polys, polys_plot, polys_ids, registered_centers, is_bound] = adjacent_polys(central_pol, ...
    region, counter_id, registered_centers, poly_n_sides, poly_side_length, angle)
%adjacent_pols Create all adjacent polygons
    
    if nargin < 7
        angle = 0;
    end
    polys = [];
    polys_plot = [];
    polys_ids = [];
    is_bound = false;
    
    [vecs, ~] = perpendicular_vecs(central_pol);
    theta = pi / central_pol.n_sides;
    apotema = central_pol.len / (2 * tan(theta));

    for i=1:central_pol.n_sides
        repeated = false;
        new_center = central_pol.center + 2 * apotema * vecs(:,i);
        [poly, poly_plot] = create_poly(counter_id + 1, poly_n_sides, new_center', poly_side_length, angle);
        centers_dist = [];
        [~, registered_size] = size(registered_centers);
        for j=1:registered_size
            centers_dist = centers_distance(poly.center, registered_centers(:,j));
            if centers_dist <= 1e-12
                repeated = true;
                break
            end
        end
        if is_inside(poly.vertices, region) && ~repeated
            counter_id = counter_id + 1;
            polys = [polys poly];
            polys_plot = [polys_plot poly_plot];
            polys_ids = [polys_ids, counter_id];
            registered_centers = [registered_centers, poly.center];
        elseif ~is_inside(poly.vertices, region)
            is_bound = true;
        end
    end
end

