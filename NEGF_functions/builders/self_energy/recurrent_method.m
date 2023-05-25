function sigma = recurrent_method(G, alpha, beta, tau, energy, eta, stop_cond)
    sigma = {};
    func_ids = unique([G.Nodes.contact_id]);
    contact_ids = func_ids(func_ids ~= int8(0));
    
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