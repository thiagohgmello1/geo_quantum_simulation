function [mu, gen, mat, iter] = set_params(system, gen, mat, iter, num)
%set_params Set all paramas from input data
    
    % Material properties
    % mat.a = system.mat_props.lattice_len;
    % mat.n_sides = system.mat_props.n_sides;
    mat.t = system.mat_props.hoppings;
    mat.epsilon = system.mat_props.onsite;
    
    gen.temp = system.mat_props.temp;
    

    % Convergency properties
    iter.conv.eta = system.conv_params.eta;
    iter.conv.self_e_stop = system.conv_params.self_e_conv;
    iter.conv.U_tol = system.conv_params.delta_U;
    iter.conv.max_iter = system.conv_params.max_iter;
    

    % cálculo do potencial eletroquímico. É baseado em um valor de 
    % referência do material e na fórmula u2-u1=-qV (u2 é o terminal - e u1
    % é o terminal +)
    mu = set_mu(system, gen.eq_fermi_energy);

    
    % Energy range: deve ser maior do que o maior u e menor do que o menor
    % u. É usual escolher valores acima e abaixo por 4 * kB * temp
    energy_1 = min(mu) - 10 * gen.kB * gen.temp;
    energy_n = max(mu) + 10 * gen.kB * gen.temp;
    iter.energy.vec = linspace(energy_1, energy_n, num.energy_points);
    iter.energy.delta = (energy_n - energy_1) / num.energy_points;
    iter.energy.start = energy_1;
    iter.energy.stop = energy_n;
    iter.energy.points = num.energy_points;
end


function mu = set_mu(system, eq_fermi_energy)
    dir_bounds = [system.boundaries.dir.params];
    mu = zeros(length(dir_bounds), 1);
    for i=1:length(dir_bounds)
        mu(i) = eq_fermi_energy - dir_bounds(i).r;
    end
end






