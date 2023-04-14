function apply_bounds(model, bounds)
%apply_bounds apply boundaries conditions
dir_length = length(bounds.dir);
neu_length = length(bounds.neu);
specified_bounds = [];

specified_bounds = set_dir_bounds(model, bounds, dir_length, specified_bounds);
specified_bounds = set_neu_bounds(model, bounds, neu_length, specified_bounds);
set_remaining_bounds(model, specified_bounds);

end


function specified_bounds = set_dir_bounds(model, bounds, dir_length, specified_bounds)
    for i=1:dir_length
        h = bounds.dir(i).params.h;
        r = bounds.dir(i).params.r;
        edges = bounds.dir(i).edges;
        specified_bounds = [specified_bounds, edges];
        for j=1:length(edges)
            applyBoundaryCondition(model,'dirichlet','Edge',edges(j),'h',h, 'r', r);
        end
    end
end


function specified_bounds = set_neu_bounds(model, bounds, neu_length, specified_bounds)
    for i=1:neu_length
        q = bounds.neu(i).params.q;
        g = bounds.neu(i).params.g;
        edges = bounds.neu(i).edges;
        specified_bounds = [specified_bounds, edges];
        for j=1:length(edges)
            applyBoundaryCondition(model,'neumann','Edge',edges(j),'q',q, 'g', g);
        end
    end
end


function set_remaining_bounds(model, specified_bounds)
    for i=1:model.Geometry.NumEdges
        if ~any(specified_bounds(:) == i)
            applyBoundaryCondition(model,'neumann','Edge',i,'q',0, 'g', 0);
        end
    end
end
