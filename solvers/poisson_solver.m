function results = poisson_solver(delta_rho, G, model, a)
%poisson_solver Solve Poisson equation

    recursively_apply_params(delta_rho, G, model, a);
    results = solvepde(model);
end