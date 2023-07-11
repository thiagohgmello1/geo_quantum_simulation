function [sigma , SGF] = recurrent_method2(G, alpha, beta, tau, energy, eta, stop_cond)
    func_ids = unique([G.Nodes.contact_id]);
    contact_ids = func_ids(func_ids ~= int8(0));
    SGF = {1, length(contact_ids)};
    sigma = {1, length(contact_ids)};
    
    for i=1:length(contact_ids)
        t = calc_t(energy, alpha{i}, beta{i}, eta, stop_cond);
    end
end


function t = calc_t(energy, alpha, beta, eta, stop_cond)
    E = energy + 1j * eta;
    I = eye(length(alpha));
    t1 = (E * I - alpha) \ I * beta';
    t2 = (E * I - alpha) \ I * beta;
    t.t = {t1};
    t.t_trans = {t2};
    while true
        aux = (I - t.t{end} * t.t_trans{end} - t.t_trans{end} * t.t{end}) \ I;
        t.t(end + 1) = {aux * t.t{end}^2};
        t.t_trans(end + 1) = {aux * t.t_trans{end}^2};
    end



end





