function results = poisson_solver(rho, G, model, a)
%poisson_solver Solve Poisson equation

    recursively_apply_params(-rho, G, model, a);
    results = solvepde(model);
end