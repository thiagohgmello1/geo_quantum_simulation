function V = calc_V(G, results)
%calc_U calculate U potencial matrix
    
    x = G.Nodes.coord(:,1);
    y = G.Nodes.coord(:,2);
    result_interpol = interpolateSolution(results, x, y);
    V = diag(result_interpol);
end