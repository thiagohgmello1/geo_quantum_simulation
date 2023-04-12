function [dist, projection] = dist_point_to_line(pt, v1, v2)
    l2 = norm(v1 - v2)^2;
    if (l2 == 0.0)
        dist = norm(p - v);
        projection = [0, 0];
    else
        t = max(0, min(1, dot(pt - v1, v2 - v1) / l2));
        projection = v1 + t * (v2 - v1);
        dist = norm(pt - projection);
    end
end