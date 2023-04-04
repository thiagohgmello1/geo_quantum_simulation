function plot_graph(G, varargin)
%plot_graph plot graph following specific nodes positions

    defaultShowNames = false;
    defaultNewFigure = true;
    p = inputParser;
    addRequired(p,'G');
    addOptional(p, 'show_names', defaultShowNames);
    addOptional(p, 'new_figure', defaultNewFigure);
    parse(p, G, varargin{:});

    coords = vertcat(G.Nodes.coord);
    nodes_colors = vertcat(G.Nodes.color);

    x = coords(:,1);
    y = coords(:,2);
    
    if p.Results.new_figure
        figure;
    end

    if p.Results.show_names
        plot(G,'XData',x,'YData',y, 'NodeLabel', G.Nodes.Name, 'NodeColor', nodes_colors);
    else
        plot(G,'XData',x,'YData',y, 'NodeColor', nodes_colors);
    end
end

