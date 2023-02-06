function [geometry, polygons] = read_geometry(file_name, scale, draw)
%read_geometry Read SVG file as problem geometry

if nargin < 3
    draw = false;
end
svg_geometry = loadSVG(file_name);

if draw
    plotSVG(svg_geometry);
end

polygons = {};
for layer=1:length(svg_geometry.layers)
    for polys=1:length(svg_geometry.layers{layer}.polys)
        pol = [2, length(svg_geometry.layers{layer}.polys{polys})];
        pol = [pol reshape(svg_geometry.layers{layer}.polys{polys}.',1,[])];
        polygons{end + 1} = pol';
    end
end

polygons = resize_polygons(polygons);

polygons = cell2mat(polygons);
polygons(3:end) = polygons(3:end) * scale;
geometry = decsg(polygons);

end


function [resized_polygons] = resize_polygons(plgs)

[nrows, ncolumns] = cellfun(@size,plgs);
max_rows = max(nrows);
for i=1:length(plgs)
    if length(plgs{i}) < max_rows
        plgs{i} = [plgs{i}; zeros(max_rows - length(plgs{i}),1)];
    end
end
resized_polygons = plgs;
end

