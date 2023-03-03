function center = set_initial_pos(region, n_sides, poly_side_length)
%set_initial_pos set first polygon position
    
    bbox = create_bbox(region);
    inside = false;
    x = (bbox(2)-bbox(1)).*rand() + bbox(1);
    y = (bbox(4)-bbox(3)).*rand() + bbox(3);
    center = [x, y];
    while ~inside
        pol = create_poly(1, n_sides, center, poly_side_length);
        if is_inside(pol.vertices, region)
            inside = true;
        else
           x = (bbox(2)-bbox(1)).*rand() + bbox(1);
           y = (bbox(4)-bbox(3)).*rand() + bbox(3);
           center = [x, y];
        end
    end
end