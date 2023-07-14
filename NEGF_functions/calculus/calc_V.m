function V = calc_V(G, results)
%calc_U calculate U potencial matrix
    
    x = G.Nodes.coord(:,1);
    y = G.Nodes.coord(:,2);
    result_interpol = interpolateSolution(results, x, y);
    result_interpol = interpol_out_nodes(G, result_interpol);
    V = diag(result_interpol);
end


function result_interpol = interpol_out_nodes(G, result_interpol)
    out_nodes = find(isnan(result_interpol));
    for node=out_nodes'
        neigs = neighbors(G, node);
        neigs_volt = result_interpol(neigs);
        result_interpol(node) = mean(neigs_volt);
    end
end