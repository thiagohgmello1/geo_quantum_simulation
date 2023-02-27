function plot_graph(G,nodes,show_names)
%plot_graph plot graph following specific nodes positions

    if nargin < 3
        show_names = false;
    end

    coords = cell2mat({nodes.coord}');
    x = coords(:,1);
    y = coords(:,2);
    if show_names
        plot(G,'XData',x,'YData',y, 'NodeLabel', G.Nodes.Name);
    else
        plot(G,'XData',x,'YData',y);
    end
end

