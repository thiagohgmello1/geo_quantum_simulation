function [green, A, Gamma, Sigma] = Green(G, G_channel, energy, H, mu, gen, iter, num, per_structs)
    fermi_levels = calc_fermi_levels(energy, mu, gen.temp, gen.kB);
    [Gamma, Sigma] = build_contacts(G, iter, energy, fermi_levels, num.method, per_structs);
    [green, A] = build_greens_params(G_channel, energy , H, Sigma, iter.conv.eta);
end