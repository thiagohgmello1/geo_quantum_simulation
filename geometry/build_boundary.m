function boundary = build_boundary(first_boundary)
%build_boundary build boundary for specific geometry

    x = first_boundary(:,1,:);
    x = reshape(x, [], 1);
    y = first_boundary(:,2,:);
    y = reshape(y, [], 1);
    boundary = [x, y];
    boundary = uniquetol(boundary, 1e-12, 'ByRows', true);
    
end

