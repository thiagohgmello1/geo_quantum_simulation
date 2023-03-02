function plot_graph(G, show_names)
%plot_graph plot graph following specific nodes positions

    if nargin < 2
        show_names = false;
    end

    coords = vertcat(G.Nodes.coord);
    x = coords(:,1);
    y = coords(:,2);
    figure;
    if show_names
        plot(G,'XData',x,'YData',y, 'NodeLabel', G.Nodes.Name);
    else
        plot(G,'XData',x,'YData',y);
    end
end

