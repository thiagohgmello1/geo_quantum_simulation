function num = numerical_consts()
%NUMERICAL_CONSTS Summary of this function goes here
%   Detailed explanation goes here
    
    num = struct();

    % R parameters
    num.R.value = 1e10;
    num.R.precision = 1e-10;
    num.R.max_iter = 100;

    num.method = 1;
    num.energy_points = 100;

    % rho_neq parameters
    num.rho_neq.npg = 3;      % Number of Gauss points for integral calculations

    % rho_eq parameters
    num.rho_eq.n_poles = 60;  % Number of poles for approximation
end

