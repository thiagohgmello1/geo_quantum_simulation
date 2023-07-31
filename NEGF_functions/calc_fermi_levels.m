function fermi_levels = calc_fermi_levels(energy, mu, temp, kB)
    fermi_levels = zeros(length(mu), 1);
    for i=1:length(mu)
        fermi_levels(i) = 1 / (1 + exp((energy - mu(i)) / (kB * temp)));
    end
end

