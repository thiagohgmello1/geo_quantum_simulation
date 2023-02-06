function apply_mesh(model, mesh_params)
%apply_mesh Apply mesh parameters

h_grad = mesh_params.growth_rate;
h_max = mesh_params.max_edge;
h_min = mesh_params.min_edge;

if h_max < 0 && h_min < 0
    generateMesh(model, 'Hgrad', h_grad);
elseif h_min < 0
    generateMesh(model, 'Hgrad', h_grad, 'Hmax', h_max);
elseif h_max < 0
    generateMesh(model, 'Hgrad', h_grad, 'Hmin', h_min);
else
    generateMesh(model, 'Hgrad', h_grad, 'Hmax', h_max, 'Hmin', h_min);
end

end

