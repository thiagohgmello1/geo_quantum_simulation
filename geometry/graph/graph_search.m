function visited_nodes = graph_search(G_dir, start_node, stop_nodes, visited_nodes)
%graph_search search all visited nodes between start node and stop nodes
    
    success = string(successors(G_dir, start_node));
    if any(contains(success, stop_nodes))
        visited_nodes = [visited_nodes string(start_node)];
        return
    end
    for suc=success'
        if ~isempty(visited_nodes) && contains(string(suc), visited_nodes)
            continue
        end
        visited_nodes = graph_search(G_dir, string(suc), stop_nodes, visited_nodes);
    end
    visited_nodes = [visited_nodes string(start_node)];
end