function recursively_apply_params(rho, G, model, a)
%recursively_apply_params apply diferential equation parameters

    params = {};
    fcoeff = @(location, state) calc_f(location, state, rho, G, a);
    m = model.EquationCoefficients.CoefficientAssignments.m;
    d = model.EquationCoefficients.CoefficientAssignments.d;
    c = model.EquationCoefficients.CoefficientAssignments.c;
    a = model.EquationCoefficients.CoefficientAssignments.a;

    params.a = a;
    params.m = m;
    params.d = d;
    params.c = c;
    params.f = fcoeff;
    
    apply_params(model, params);
end


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









