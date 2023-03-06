function [nodes, polys_array] = create_nodes(polys_array, tol)
%create_nodes create a list of nodes
    
    if nargin < 2
        tol = 1e-12;
    end
    
    nodes = [];
    nodes_list = [];
    n_polys = length(polys_array);
    counter = 1;

    for pol=1:n_polys
        n_sides = polys_array(pol).n_sides;
        conn_order = 1:n_sides;
        conn_order = circshift(conn_order,-1);
        
        edges = polys_array(pol).vertices;
        internal_pos_vec = [];
        for edge=1:length(edges)
            if ~isempty(nodes)
                check_existance = ismembertol(nodes_list, edges(edge,:), tol, 'ByRows',true);
            else
                check_existance = false;
            end
            if isempty(nodes) || ~any(check_existance)
                nodes_list = [nodes_list; edges(edge,:)];
                node = create_node(edges(edge,:), counter, polys_array(pol).is_bound);
                internal_pos_vec(edge) = counter;
                counter = counter + 1;
                nodes = [nodes, node];
            else
                internal_pos_vec(edge) = find(check_existance);
            end
            polys_array(pol).nodes = [polys_array(pol).nodes, internal_pos_vec(edge)];
        end
        for edge=1:length(internal_pos_vec)
            node_pos1 = internal_pos_vec(edge);
            node_pos2 = internal_pos_vec(conn_order(edge));
            if ~ismember(node_pos2, nodes(node_pos1).neighbors)
                nodes(node_pos1).neighbors = [nodes(node_pos1).neighbors, node_pos2];
                nodes(node_pos2).neighbors = [nodes(node_pos2).neighbors, node_pos1];
            end
        end
    end
end


