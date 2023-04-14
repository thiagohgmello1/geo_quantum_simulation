function results = poisson_solver(model, varargin)
%poisson_solver Solve Poisson equation

    defaultEpsilon = false;
    defaultG = false;
    defaultA = false;
    defaultRho = false;

    p = inputParser;
    validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
    addRequired(p,'model');
    addOptional(p, 'epsilon', defaultEpsilon);
    addOptional(p, 'G', defaultG);
    addOptional(p, 'a', defaultA, validScalarPosNum);
    addOptional(p, 'rho', defaultRho);
    parse(p, model, varargin{:});

    epsilon = p.Results.epsilon;
    G = p.Results.G;
    a = p.Results.a;
    rho = p.Results.rho;

    if ~a
        results = solvepde(model);
    else
        recursively_apply_params(-rho / epsilon, G, model, a);
        results = solvepde(model);
    end
end