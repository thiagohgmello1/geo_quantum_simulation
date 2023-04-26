function D = calc_TDOS(A)
%cal_TDOS calculate total density of states at specified energy

    D = 1 / (2 * pi) * trace(A);
end