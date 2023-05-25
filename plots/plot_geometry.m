function plot_geometry(polygon, polygons, polygons_struct, nodes, show_nodes_numbers, show_polys_numbers)
%plot_geometry plot geometry and polygons
    figure;
    plot(polygons, 'FaceColor','red')
    hold on;
    plot(polygon(:,1), polygon(:,2))
    if show_nodes_numbers
        for i=1:length(nodes)
            x = nodes(i).coord(1);
            y = nodes(i).coord(2);
            id = num2str(nodes(i).id);
            text(x, y, id)
        end
    end
    if show_polys_numbers
        for i=1:length(polygons)
            x = polygons_struct(i).center(1);
            y = polygons_struct(i).center(2);
            id = num2str(polygons_struct(i).id);
            text(x, y, id, 'Color','blue')
        end
    end
    hold off;
end

