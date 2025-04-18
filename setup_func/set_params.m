function [mu, gen, mat, iter] = set_params(system, gen, mat, iter, num)
%set_params Set all paramas from input data
    
    mu = set_mu(system, gen.chemical_pot);
    
    energy_1 = min(mu) - 10 * gen.kB * gen.temp;
    energy_n = max(mu) + 10 * gen.kB * gen.temp;
    iter.energy.vec = linspace(energy_1, energy_n, num.energy_points);
    iter.energy.delta = (energy_n - energy_1) / num.energy_points;
    iter.energy.start = energy_1;
    iter.energy.stop = energy_n;
    iter.energy.points = num.energy_points;
end


function mu = set_mu(system, chemical_pot)
% Electrochemical potential calculation
% [chemical_pot] = eV[chemical_pot] = eV, [mu] = eV
    dir_bounds = [system.boundaries.dir.params];
    mu = zeros(length(dir_bounds), 1);
    for i=1:length(dir_bounds)
        mu(i) = chemical_pot(i) - dir_bounds(i).r;
    end
end






