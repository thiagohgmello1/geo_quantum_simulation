function [nodes, polys_array] = create_nodes(polys_array, varargin)
%create_nodes create a list of nodes
    
    defaultTol = 1e-12;
    defaultCounter = 1;

    p = inputParser;
    validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
    addRequired(p,'polys_array');
    addOptional(p, 'tol', defaultTol);
    addOptional(p, 'counter', defaultCounter, validScalarPosNum);
    parse(p, polys_array , varargin{:});
    counter = p.Results.counter;
    pos_offset = p.Results.counter - 1;
    
    nodes = [];
    nodes_list = [];
    n_polys = length(polys_array);

    for pol=1:n_polys
        n_sides = polys_array(pol).n_sides;
        conn_order = circshift(1:n_sides,-1);
        vertices = polys_array(pol).vertices;
        internal_pos_vec = [];
        for vertex=1:length(vertices)
            if ~isempty(nodes)
%                 check_existance = ismembertol(nodes_list, vertices(vertex,:), p.Results.tol, 'ByRows', true);
                check_existance = all(is_close(nodes_list, vertices(vertex,:), 'rtol', 0, 'atol', 1e-12), 2);
            else
                check_existance = false;
            end
            if isempty(nodes) || ~any(check_existance)
                nodes_list = [nodes_list; vertices(vertex,:)];
                node = create_node(vertices(vertex,:), counter, polys_array(pol).is_bound, polys_array(pol).center);
                internal_pos_vec(vertex) = counter;
                counter = counter + 1;
                nodes = [nodes, node];
            else
                internal_pos_vec(vertex) = find(check_existance) + pos_offset;
                nodes(check_existance).is_bound = nodes(check_existance).is_bound || polys_array(pol).is_bound;
            end
            polys_array(pol).nodes = [polys_array(pol).nodes, internal_pos_vec(vertex)];
        end
        nodes = insert_neighbors(nodes, internal_pos_vec, conn_order);
    end
end


function nodes = insert_neighbors(nodes, internal_pos_vec, conn_order)
    nodes_ids = [nodes.id];
    for vertex=1:length(internal_pos_vec)
        node_pos1 = internal_pos_vec(vertex);
        desired_pos1 = nodes_ids == node_pos1;
        node_pos2 = internal_pos_vec(conn_order(vertex));
        desired_pos2 = nodes_ids == node_pos2;
        if ~ismember(node_pos2, nodes(desired_pos1).neighbors)
            nodes(desired_pos1).neighbors = [nodes(desired_pos1).neighbors, node_pos2];
            nodes(desired_pos2).neighbors = [nodes(desired_pos2).neighbors, node_pos1];
        end
    end
end
