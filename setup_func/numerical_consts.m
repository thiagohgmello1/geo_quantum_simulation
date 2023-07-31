function num = numerical_consts()
%NUMERICAL_CONSTS Summary of this function goes here
%   Detailed explanation goes here
    
    num = struct();

    % R parameters
    num.R.precision = 1e-20;
    num.R.max_iter = 100;

    num.method = 1;
    num.energy_points = 1000;

    % rho_neq parameters
    num.rho_neq.npg = 3;

    % rho_eq parameters
    num.rho_eq.n_poles = 60;
end

