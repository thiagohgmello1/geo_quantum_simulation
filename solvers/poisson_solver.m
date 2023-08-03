function results = poisson_solver(model, gen, varargin)
%poisson_solver Solve Poisson equation

    defaultG = false;
    defaultA = false;
    defaultRho = false;
    defaultVol = false;

    p = inputParser;
    validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
    addRequired(p,'model');
    addRequired(p,'gen');
    addOptional(p, 'Vol', defaultVol);
    addOptional(p, 'G', defaultG);
    addOptional(p, 'a', defaultA, validScalarPosNum);
    addOptional(p, 'rho', defaultRho);
    parse(p, model, gen, varargin{:});

    G = p.Results.G;
    a = p.Results.a;
    rho = p.Results.rho;
    Vol = p.Results.Vol;

    recursively_apply_params(-gen.q * rho / (gen.e_0 * Vol), G, model, a);
    results = solvepde(model);
end