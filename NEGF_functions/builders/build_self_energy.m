function sigma = build_self_energy(G, epsilon, t, energy, eta, stop_cond, system, a)
%build_self_energy build self energy matrices for contacts

    contact_trans_dir = [system.boundaries.dir.params];
    contact_trans_dir = vertcat(contact_trans_dir.trans_dir);
    [alpha, beta, tau] = def_periodic_structures(G, contact_trans_dir, a, epsilon, t);

    func_ids = unique([G.Nodes.contact_id]);
    contact_ids = func_ids(func_ids ~= int8(0));

    sigma = {};
    
    for i=1:length(contact_ids)
        gn = iterate_gn(alpha{contact_ids(i)}, beta{contact_ids(i)}, energy, eta, stop_cond);
        sigma{end + 1} = tau{contact_ids(i)} * gn * tau{contact_ids(i)}';
    end
end


function g_after = iterate_gn(alpha, beta, energy, eta, stop_cond)
    I = eye(length(alpha));
    change = inf;
    g_before = zeros(length(I));
    g_after = g_before;
    while change > stop_cond
        g_aux = (energy + 1i*eta) * I - alpha - beta * g_before *  beta';
        g_after = g_aux \ I;
        change = sum(sum(abs(g_before - g_after)))/(sum(sum(abs(g_after) + abs(g_before))));
        g_after = 0.5 * g_before + 0.5 * g_after;
        g_before = g_after;
    end
end

