function [dist] = centers_distance(pol1,pol2)
%centers_distance calculate distance between two polygons centers
    
    x = pol1(1) - pol2(1);
    y = pol1(2) - pol2(2);
    dist = sqrt(x^2 + y^2);
end

