function results = poisson_solver(model, epsilon, G, neig_dist, rho)
%poisson_solver Solve Poisson equation

    if nargin < 2
        results = solvepde(model);
    else
        recursively_apply_params(-rho / epsilon, G, model, neig_dist);
        results = solvepde(model);
    end
end