function [Gamma, Sigma] = build_contacts(G, epsilon, t, energy, eta, stop_cond, fermi_levels, a, system, method)
%build_contact build contact matrices

    Sigma = struct();
    Sigma.sigma = build_self_energy(G, epsilon, t, energy, eta, stop_cond, system, a, method);
    Sigma.sigma_in = {};
    Gamma = {};

    for i=1:length(Sigma.sigma)
        Gamma{end + 1} = 1i * (Sigma.sigma{i} - Sigma.sigma{i}');
        Sigma.sigma_in{end + 1} = Gamma{i} * fermi_levels(i);
    end
end