function [polys, polys_ids, registered_centers, is_bound] = adjacent_polys(central_pol, ...
    region, counter_id, registered_centers, poly_n_sides, a, varargin)
%adjacent_pols Create all adjacent polygons

    defaultAngle = 90;
    p = inputParser;
    validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
    addRequired(p,'central_pol');
    addRequired(p,'region');
    addRequired(p,'counter_id', validScalarPosNum);
    addRequired(p,'registered_centers');
    addRequired(p, 'poly_n_sides', validScalarPosNum);
    addRequired(p, 'a');
    addOptional(p, 'angle', defaultAngle);
    parse(p, central_pol, region, counter_id, registered_centers, poly_n_sides, varargin{:});
    angle = p.Results.angle;

    polys = [];
    polys_ids = [];
    is_bound = false;
    
    [vecs, ~] = perpendicular_vecs(central_pol);
    theta = pi / central_pol.n_sides;
    apotema = central_pol.len / (2 * tan(theta));

    for i=1:central_pol.n_sides
        repeated = false;
        new_center = central_pol.center + 2 * apotema * vecs(:,i);
        [adjacent_poly, ~] = create_poly(counter_id + 1, poly_n_sides, new_center', a, 'angle', angle);
        centers_dist = [];
        [~, registered_size] = size(registered_centers);
        for j=1:registered_size
            centers_dist = centers_distance(adjacent_poly.center, registered_centers(:,j));
            if centers_dist <= 1e-12
                repeated = true;
                break
            end
        end
        if is_inside(adjacent_poly.vertices, region) && ~repeated
            counter_id = counter_id + 1;
            polys = [polys adjacent_poly];
            polys_ids = [polys_ids, counter_id];
            registered_centers = [registered_centers, adjacent_poly.center];
        elseif ~is_inside(adjacent_poly.vertices, region)
            is_bound = true;
        end
    end
end

