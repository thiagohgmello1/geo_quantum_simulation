function [sigma, SGF] = recurrent_method(G, alpha, beta, tau, energy, eta, stop_cond)
    
    func_ids = unique([G.Nodes.contact_id]);
    contact_ids = func_ids(func_ids ~= int8(0));
    SGF = {1, length(contact_ids)};
    sigma = {1, length(contact_ids)};
    
    for i=1:length(contact_ids)
        SGF{i} = iterate_SGF(alpha{contact_ids(i)}, beta{contact_ids(i)}, energy, eta, stop_cond);
        sigma{i} = tau{contact_ids(i)} * SGF{i} * tau{contact_ids(i)}';
    end
end

function g_after = iterate_SGF(alpha, beta, energy, eta, stop_cond)
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