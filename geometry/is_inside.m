function inside = is_inside(pol, region)
%is_inside Check if pol is inside region

    inside = all(inpolygon(pol(:,1),pol(:,2),region(:,1),region(:,2)));
end

