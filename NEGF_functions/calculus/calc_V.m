function V = calc_V(G, results)
%calc_U calculate U potencial matrix
    
    x = G.Nodes.coord(:,1);
    y = G.Nodes.coord(:,2);
    interpol = interpolateSolution(results, x, y);
    interpol = interpol_out_nodes(G, interpol);
    V = diag(interpol);
end


function interpol = interpol_out_nodes(G, interpol)
    out_nodes = find(isnan(interpol));
    for node=out_nodes'
        neigs = neighbors(G, node);
        neigs = neigs(~isnan(neigs));
        neigs_volt = interpol(neigs);
        interpol(node) = mean(neigs_volt);
    end
end