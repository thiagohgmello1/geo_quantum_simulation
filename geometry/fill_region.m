function [polys, polys_plot, boundary] = fill_region(region, poly_n_sides, poly_length, first_center)
%fill_region fill specified region with polygons

    polys = [];
    polys_plot = [];
    boundary = [];
    [pol, poly_plot] = create_poly(1, poly_n_sides, first_center, poly_length);
    polys = [polys, pol];
    polys_plot = [polys_plot, poly_plot];

    unchecked_polys = [1];
    centers = [pol.center];

    while ~isempty(unchecked_polys)
        pos = unchecked_polys(1);
        [polys_aux, polys_plot_aux, polys_ids_aux, centers, boundary_aux] = adjacent_polys(polys(pos), ...
            region, unchecked_polys(end), centers, poly_n_sides, poly_length);
        if ~isempty(boundary_aux)
            boundary = cat(3, boundary, boundary_aux);
        end
        unchecked_polys = [unchecked_polys, polys_ids_aux];
        unchecked_polys(1) = [];
        polys = [polys, polys_aux];
        polys_plot = [polys_plot, polys_plot_aux];
    end

end

