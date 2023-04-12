function bbox = create_bbox(region)
%create_bbox create rectangular box for region
    
    x_min = min(region(:,1));
    x_max = max(region(:,1));
    y_min = min(region(:,2));
    y_max = max(region(:,2));
    
    bbox = [x_min, x_max, y_min, y_max];
end

