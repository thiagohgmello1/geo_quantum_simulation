function [mat_props, converg_props, mu, energy_props] = set_params(system, eq_fermi_energy, energy_points, kB)
%set_params Set all paramas from input data

    mat_props = {};
    converg_props = {};
    energy_props = {};
    
    % Material properties
    % a = system.mat_props.lattice_len;
    % n_sides = system.mat_props.n_sides;
    t = system.mat_props.hoppings;
    epsilon = system.mat_props.onsite;
    temp = system.mat_props.temp;
    % mat_props{end + 1} = a;
    % mat_props{end + 1} = n_sides;
    mat_props{end + 1} = t;
    mat_props{end + 1} = epsilon;
    mat_props{end + 1} = temp;
    

    % Convergency properties
    eta = system.conv_params.eta;
    stop_cond = system.conv_params.self_e_conv;
    U_tol = system.conv_params.delta_U;
    max_iter = system.conv_params.max_iter;
    converg_props{end + 1} = eta;
    converg_props{end + 1} = stop_cond;
    converg_props{end + 1} = U_tol;
    converg_props{end + 1} = max_iter;
    

    % cálculo do potencial eletroquímico. É baseado em um valor de 
    % referência do material e na fórmula u2-u1=-qV (u2 é o
    % terminal - e u1 é o terminal +
    mu = set_mu(system, eq_fermi_energy);

    
    % Energy range: deve ser maior do que o maior u e menor do que o menor
    % u. É usual escolher valores acima e abaixo por 4 * kB * temp
%     energy_1 = min(mu) - 4 * kB * temp;
%     energy_n = max(mu) + 4 * kB * temp;
    energy_1 = -1;
    energy_n = 1;
    delta_energy = (energy_n - energy_1) / energy_points;
%     energy_vec = t * linspace(energy_1, energy_n, energy_points);
    energy_vec = linspace(energy_1, energy_n, energy_points);
    energy_props{end + 1} = energy_1;
    energy_props{end + 1} = energy_n;
    energy_props{end + 1} = energy_points;
    energy_props{end + 1} = delta_energy;
    energy_props{end + 1} = energy_vec;
end


function mu = set_mu(system, eq_fermi_energy)
    dir_bounds = [system.boundaries.dir.params];
    mu = zeros(length(dir_bounds), 1);
    for i=1:length(dir_bounds)
        mu(i) = eq_fermi_energy - dir_bounds(i).r;
    end
end






