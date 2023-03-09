function edges = get_edges(geometry, roi)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    edges = [];
    edges_len = size(geometry, 2);
    for i=1:edges_len
        x = geometry(2:3, i);
        y = geometry(4:5, i);
        is_inside_pol = inROI(roi, x, y);
        if all(is_inside_pol)
            edges = [edges i];
        end
    end
end