function [outputArg1,outputArg2] = build_H(G, nodes, epsilon, t, axis_direction)
%build_H build H matrix of NEGF method

    if nargin < 5
        axis_direction = 1;
    end
    H = ones(length(nodes));
    idx = 1;
    while idx <= length(nodes)
        indices = find_indices_by_coord(G, idx, axis_direction);
        idx = indices(end) + 1;
        next_indices = find_indices_by_coord(G, idx, axis_direction);
        alpha = epsilon * eye(length(indices));
        beta_forward = build_beta_forward(indices, G, axis_direction);
    end
end

