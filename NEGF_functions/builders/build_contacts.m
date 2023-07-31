function [Gamma, Sigma] = build_contacts(G, mat, iter, energy, fermi_levels, system, method)
%build_contact build contact scattering (Sigma_in) and self-energy (Sigma) 
% matrices

    Sigma = struct();
    Sigma.sigma = build_self_energy(G, mat.epsilon, mat.t, energy, ...
        iter.conv.eta, iter.conv.self_e_stop, system, mat.a, method);
    Sigma.sigma_in = {};
    Gamma = {};

    for i=1:length(Sigma.sigma)
        Gamma{end + 1} = 1i * (Sigma.sigma{i} - Sigma.sigma{i}');
        Sigma.sigma_in{end + 1} = Gamma{i} * fermi_levels(i);
    end
end