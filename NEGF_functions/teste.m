idx = 1;
while idx <= length(nodes)
    x_pos = nodes(idx).coord(1);
    indices = find_coord(nodes, x_pos);
    idx = indices(end) + 1;
end
