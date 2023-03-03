function f_level = fermi_level(energy, mu, temp)
%fermi_level define fermi level for specific eneergy and electrochemical potential
    
    kB = 8.6173324 * 1e-5; % Boltzmann constant in eV/K
    f_level = 1 / (1+exp((energy - mu) / (kB * temp)));
end