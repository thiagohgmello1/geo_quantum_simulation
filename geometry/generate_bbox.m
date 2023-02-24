function grid = generate_bbox(region, n_sides, side_length, TEST)
%generate_grid generate a regular grid with side of side_length
    
    if nargin < 4
        TEST = false;
    end
    
    pol_counter = 0;
    polygons = [];
    
    x_min = min(region(:,1));
    x_max = max(region(:,1));
    y_min = min(region(:,2));
    y_max = max(region(:,2));
    
    x_rand = (x_max-x_min).*rand() + x_min;
    y_rand = (y_max-y_min).*rand() + y_min;
    
    if TEST
        plot(region(:,1), region(:,2));
        hold on;
        plot(x_rand, y_rand, '*r');
    end
    
    while ~inpolygon(x_rand, y_rand, region(:,1), region(:,2))
        x_rand = (x_max-x_min).*rand() + x_min;
        y_rand = (y_max-y_min).*rand() + y_min;
        
        if TEST
            plot(x_rand, y_rand, '*r');
        end
    end
    
    if TEST
        hold off;
    end
    
    
    
end

