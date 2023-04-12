function rot_pol = rotate_polygon(pol, angle)
%rotate Rotate polygon by "angle" degrees

    R = [cosd(angle),-sind(angle);sind(angle),cosd(angle)];
    rot_pol = pol * R;
end

