function f = calc_f(location, state, rho_in, G, neig_dist)
%calc_f calculate f coefficient for PDE equation
    
    points = [location.x(:), location.y(:)];
    coords = G.Nodes.coord;

    Idx = rangesearch(coords, points, 1.1 * neig_dist);
    f = zeros([1, size(points, 1)]);
    for i=1:size(Idx, 1)
        f(i) = mean(rho_in(Idx{i,1}));
    end
end