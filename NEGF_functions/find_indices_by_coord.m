function indices = find_indices_by_coord(G, idx, axis_direction)
%find_coord find correspondent rows according desired_coord
    
    if nargin < 3
        axis_direction = 1;
    end
    desired_coord = G.Nodes(idx,:).coord(axis_direction);
    func = @(idx_aux) G.Nodes(idx_aux,:).coord(axis_direction) == desired_coord;
    array_func = arrayfun(func, 1:numnodes(G));
    indices = find(array_func);
end

