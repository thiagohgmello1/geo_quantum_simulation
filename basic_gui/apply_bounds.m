function apply_bounds(model, bounds)
%apply_bounds apply boundaries conditions
dir_length = length(bounds.dir);
neu_length = length(bounds.neu);
specified_bounds = [];

for i=1:dir_length
    h = bounds.dir(i).params.h;
    r = bounds.dir(i).params.r;
    edges = bounds.dir(i).edges;
    specified_bounds = [specified_bounds, edges];
    for j=1:length(edges)
        applyBoundaryCondition(model,'dirichlet','Edge',edges(j),'h',h, 'r', r);
    end
end

for i=1:neu_length
    q = bounds.neu(i).params.q;
    g = bounds.neu(i).params.g;
    edges = bounds.neu(i).edges;
    specified_bounds = [specified_bounds, edges];
    for j=1:length(edges)
        applyBoundaryCondition(model,'neumann','Edge',edges(j),'q',q, 'g', g);
    end
end

for i=1:model.Geometry.NumEdges
    if ~any(specified_bounds(:) == i)
        applyBoundaryCondition(model,'dirichlet','Edge',i,'h',1, 'r', 0);
    end
end

end

