function [vecs, segments] = perpendicular_vecs(pol)
%perpendicular_vec returns perpendicular vectors of vec
    
    segments = [];
    for i=1:pol.n_sides
        if i == pol.n_sides
            aux_vec = pol.vertices(1,:) - pol.vertices(i,:);
            segments(:,:,i) = [pol.vertices(i,:); pol.vertices(1,:)];
        else
            aux_vec = pol.vertices(i + 1,:) - pol.vertices(i,:);
            segments(:,:,i) = [pol.vertices(i,:); pol.vertices(i + 1,:)];
        end
        vecs(:,i) = rotate_vec(aux_vec');
    end
    vecs = vecs / pol.len;

end

