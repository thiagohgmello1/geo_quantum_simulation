function vec = rotate_vec(vec, angle)
%rotate Rotate vector by "angle" degrees

    if nargin < 2
        angle = 90;
    end

    R = [cosd(angle),-sind(angle);sind(angle),cosd(angle)];
    vec = R * vec;
end

