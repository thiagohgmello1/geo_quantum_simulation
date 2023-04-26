function f_level = fermi_level(energy, mu, temp, kB)
%fermi_level define fermi level for specific eneergy and electrochemical potential
    
    f_level = 1 / (1 + exp((energy - mu) / (kB * temp)));
end