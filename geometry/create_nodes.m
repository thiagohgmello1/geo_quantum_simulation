function [nodes, polys_array] = create_nodes(polys_array, tol)
%create_nodes create a list of nodes
    
    if nargin < 2
        tol = 1e-12;
    end
    
    conn_order = [2, 3, 4, 5, 6, 1];
    nodes = [];
    nodes_list = [];
    n_polys = length(polys_array);
    counter = 1;

    for pol=1:n_polys
        vertices = polys_array(pol).vertices;
        internal_pos_vec = [];
        for vertex=1:length(vertices)
            if ~isempty(nodes)
                check_existance = ismembertol(nodes_list, vertices(vertex,:), tol, 'ByRows',true);
            else
                check_existance = false;
            end
            if isempty(nodes) || ~any(check_existance)
                nodes_list = [nodes_list; vertices(vertex,:)];
                node = create_node(vertices(vertex,:), counter);
                internal_pos_vec(vertex) = counter;
                counter = counter + 1;
                nodes = [nodes, node];
            else
                internal_pos_vec(vertex) = find(check_existance);
            end
            polys_array(pol).nodes = [polys_array(pol).nodes, internal_pos_vec(vertex)];
        end
        for vertex=1:length(internal_pos_vec)
            node_pos1 = internal_pos_vec(vertex);
            node_pos2 = internal_pos_vec(conn_order(vertex));
            if ~ismember(node_pos2, nodes(node_pos1).neighbors)
                nodes(node_pos1).neighbors = [nodes(node_pos1).neighbors, node_pos2];
                nodes(node_pos2).neighbors = [nodes(node_pos2).neighbors, node_pos1];
            end
        end
    end
end


