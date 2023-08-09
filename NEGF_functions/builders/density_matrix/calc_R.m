function R = calc_R(G, G_channel, H, system, mu, gen, iter, mat, num)
%CALC_R calculates R parameter in eV

    error = inf;
    R = 32;
    mu_0_before = zeros(length(H));
    iter_counter = 1;
    if isfield(num.R,'value')
        R = num.R.value;
    else
        while (abs(error) > num.R.precision) && (iter_counter < num.R.max_iter)
            z = 1i * R;
            fermi_levels = calc_fermi_levels(z, mu, gen.temp, gen.kB);
            [~, Sigma] = build_contacts(G, mat, iter, z, fermi_levels, system, num.method);
            [Green, ~] = build_greens_params(G_channel, z , H, Sigma, iter.conv.eta);
            mu_0_after = z * Green.green_r;
            error = max(diag(mu_0_before - mu_0_after));
            mu_0_before = mu_0_after;
            R = R * 2;
            iter_counter = iter_counter + 1;
        end
    end
end

