function [I, V] = cacl_IV_curve(G_complete, G, system, model, channel_id, mat, iter, num, mu, gen, Vol, from_id, to_id)
%CACL_IV_CURVE calculate IV curve for specific topology

    V = linspace(-1 * abs(mu(1)), abs(mu(1)), iter.current.v_points);
    I = zeros(length(V), 1);
    count = 1;
    for volt=V
        mu = [-volt, volt];
        G_channel = G_nodes_by_id(G_complete, channel_id);
        [~, H] = non_eq_solver(G_complete, G, system, model, channel_id, mat, iter, num, mu, gen, Vol, from_id, to_id);
        I(count) = calc_current(G_complete, G_channel, system, H, from_id, to_id, mu, gen, iter, mat, num);
        count = count + 1;
    end
end

