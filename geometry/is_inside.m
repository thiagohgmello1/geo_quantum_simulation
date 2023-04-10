function inside = is_inside(pol, region)
%is_inside Check if pol is inside region
    
    if isa(region,'function_handle')
        inside = [];
        for i=1:length(pol)
            inside = [inside region(pol(i,1), pol(i,2))];
        end
        inside = all(inside);
%         inside = all(region(pol(:,1), pol(:,2)));
    else
        inside = all(inpolygon(pol(:,1),pol(:,2),region(:,1),region(:,2)));
    end
end

