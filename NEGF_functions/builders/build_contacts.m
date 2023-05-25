function [Gamma, Sigma, Sigma_in] = build_contacts(G, epsilon, t, energy, eta, stop_cond, fermi_levels, a, system, method)
%build_contact build contact matrices

    Sigma = build_self_energy(G, epsilon, t, energy, eta, stop_cond, system, a, method);
    Gamma = {};
    Sigma_in = {};

    for i=1:length(Sigma)
        Gamma{end + 1} = 1i * (Sigma{i} - Sigma{i}');
        Sigma_in{end + 1} = Gamma{i} * fermi_levels(i);
    end
end