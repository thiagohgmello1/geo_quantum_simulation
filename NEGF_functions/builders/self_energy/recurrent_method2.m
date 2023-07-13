function [sigma , SGF] = recurrent_method2(G, alpha, beta, tau, energy, eta, stop_cond)

    func_ids = unique([G.Nodes.contact_id]);
    contact_ids = func_ids(func_ids ~= int8(0));
    SGF = {1, length(contact_ids)};
    sigma = {1, length(contact_ids)};
    E = energy + 1j * eta;
    
    for i=1:length(contact_ids)
        SGF{i} = calc_surface_green(E, alpha{contact_ids(i)}, beta{contact_ids(i)}, stop_cond);
        sigma{i} = tau{contact_ids(i)} * SGF{i} * tau{contact_ids(i)}';
    end
end

function surface_green = calc_surface_green(E, alpha, beta, stop_cond)
    t = calc_t(E, alpha, beta, stop_cond);
    T = calc_transmission(t);
    I = eye(length(alpha));
    surface_green = (E * I - alpha - beta * T) \ I;

end


function t = calc_t(E, alpha, beta, stop_cond)
    t_max = inf;
    t_tilde_max = inf;
    I = eye(length(alpha));
    t0 = (E * I - alpha) \ I * beta';
    t0_trans = (E * I - alpha) \ I * beta;
    t.t = {t0};
    t.t_tilde = {t0_trans};
    while t_max > stop_cond && t_tilde_max > stop_cond
        aux = (I - t.t{end} * t.t_tilde{end} - t.t_tilde{end} * t.t{end}) \ I;
        t.t(end + 1) = {aux * t.t{end} ^ 2};
        t.t_tilde(end + 1) = {aux * t.t_tilde{end} ^ 2};
        t_max = abs(max(max(t.t{end})));
        t_tilde_max = abs(max(max(t.t_tilde{end})));
    end
end


function transmission = calc_transmission(t)
    len = length(t.t{1});
    transmission = zeros(len);
    for i=1:length(t.t)
        aux_var = lbd_elem(t, i, len);
        transmission = transmission + aux_var;
    end
end


function aux_var = lbd_elem(t, i, len)
    aux_var = eye(len);
    for j=1:i
        if j == i
            aux_var = aux_var * t.t{j};
        else
            aux_var = aux_var * t.t_tilde{j};
        end
    end
end







