function [green, A, Gamma, Sigma] = Green(G, G_channel, system, energy, H, U, mu, gen, iter, mat, num)
        fermi_levels = calc_fermi_levels(energy, mu, gen.temp, gen.kB);
        [Gamma, Sigma] = build_contacts(G, mat, iter, energy, fermi_levels, system, num.method);
        [green, A] = build_greens_params(G_channel, energy , H, U, Sigma, iter.conv.eta);
end