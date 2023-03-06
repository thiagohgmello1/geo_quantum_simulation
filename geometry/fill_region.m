function [polys, polys_plot] = fill_region(region, poly_n_sides, poly_length, first_center, angle)
%fill_region fill specified region with polygons
    
    if nargin < 5
        angle = 0;
    end
    polys = [];
    polys_plot = [];
    [pol, poly_plot] = create_poly(1, poly_n_sides, first_center, poly_length, angle);
    polys = [polys, pol];
    polys_plot = [polys_plot, poly_plot];

    unchecked_polys = 1;
    centers = [pol.center];

    while ~isempty(unchecked_polys)
        pos = unchecked_polys(1);
        [polys_aux, polys_plot_aux, polys_ids_aux, centers, is_bound] = adjacent_polys(polys(pos), ...
            region, unchecked_polys(end), centers, poly_n_sides, poly_length, angle);
        polys(pos).is_bound = is_bound;
        unchecked_polys = [unchecked_polys, polys_ids_aux];
        unchecked_polys(1) = [];
        polys = [polys, polys_aux];
        polys_plot = [polys_plot, polys_plot_aux];
    end

end

