function vertices = narrowest_reg(polygon)
%narrowest_reg define narrowest polygon region

x = polygon(3:end / 2 + 1);
y = polygon(end / 2 + 2:end);
pos = linspace(1,length(x), length(x));
shifted_pos = circshift(pos, 1);
lowest_dist = inf;

for i=1:length(x)
    point = [x(i), y(i)];
    for j=3:length(x)
        vertex1 = [x(pos(j)), y(pos(j))];
        vertex2 = [x(shifted_pos(j)), y(shifted_pos(j))];
        [distance, proj] = dist_point_to_line(point, vertex1, vertex2);
        if distance < lowest_dist
            lowest_dist = distance;
            vertices = [point; proj];
        end
    end
    pos = circshift(pos, -1);
    shifted_pos = circshift(shifted_pos, -1);
end


end

