function f = calc_f(location, state, rho, G, a)
%calc_f calculate f coefficient for PDE equation
    
    points = [location.x(:), location.y(:)];
    coords = G.Nodes.coord;

    Idx = rangesearch(coords, points, 1.1 * a);
    f = zeros([1, size(points, 1)]);
    for i=1:size(Idx, 1)
        f(i) = mean(rho(Idx{i,1}));
    end
end