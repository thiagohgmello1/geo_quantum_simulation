function [Gamma, Sigma] = build_contacts(G, iter, energy, fermi_levels, method, per_structs)
%build_contact build contact scattering (Sigma_in) and self-energy (Sigma) 
% matrices

    Sigma = struct();
    Sigma.sigma = build_self_energy(G, iter, energy, method, per_structs);
    Sigma.sigma_in = {};
    Gamma = {};

    for i=1:length(Sigma.sigma)
        Gamma{end + 1} = 1i * (Sigma.sigma{i} - Sigma.sigma{i}');
        Sigma.sigma_in{end + 1} = Gamma{i} * fermi_levels(i);
    end
end