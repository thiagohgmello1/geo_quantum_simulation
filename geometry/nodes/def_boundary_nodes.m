function nodes = def_boundary_nodes(nodes, polys_struct)
%def_boundarie_nodes define wich nodes belong to boundary

    n_nodes = length(nodes);
    n_polys_struct = length(polys_struct);
    bound_color = [1, 0, 0];
    

    for idx=1:n_nodes
        func = @(idx_aux) any(polys_struct(idx_aux).nodes == idx);
        array_func = arrayfun(func, 1:n_polys_struct);
        indices = find(array_func);
        polys_bounds_indicators = cell2mat(extractfield(polys_struct(indices),'is_bound'));
        nodes(idx).is_bound = nodes(idx).is_bound & all(polys_bounds_indicators);
        if nodes(idx).is_bound
            nodes(idx).color = bound_color;
        end
    end
end