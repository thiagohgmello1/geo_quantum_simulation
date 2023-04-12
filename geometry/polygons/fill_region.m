function [polys, polys_plot] = fill_region(region, n_sides, a, first_center, varargin)
%fill_region fill specified region with polygons
    
    defaultAngle = 0;
    defaultRegisCenters = [];
    p = inputParser;
    validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
    addRequired(p,'region');
    addRequired(p,'n_sides', validScalarPosNum);
    addRequired(p,'a', validScalarPosNum);
    addRequired(p,'first_center');
    addOptional(p, 'angle', defaultAngle);
    addOptional(p, 'regis_centers', defaultRegisCenters);
    parse(p, region, n_sides, a, first_center, varargin{:});
    angle = p.Results.angle;
    regis_centers = p.Results.regis_centers;

    polys = [];
    polys_plot = [];
    [pol, poly_plot] = create_poly(1, n_sides, first_center, a, 'angle', angle);
    polys = [polys, pol];
    polys_plot = [polys_plot, poly_plot];

    unchecked_polys = 1;
    centers = [regis_centers', pol.center];

    while ~isempty(unchecked_polys)
        pos = unchecked_polys(1);
        [polys_aux, polys_plot_aux, polys_ids_aux, centers, is_bound] = adjacent_polys(polys(pos), ...
            region, unchecked_polys(end), centers, n_sides, a, angle);
        polys(pos).is_bound = is_bound;
        unchecked_polys = [unchecked_polys, polys_ids_aux];
        unchecked_polys(1) = [];
        polys = [polys, polys_aux];
        polys_plot = [polys_plot, polys_plot_aux];
    end

end

