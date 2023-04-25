function D = calc_LDOS(A)
%cal_LDOS calculate local density of states at specified energy

    D = 1 / (2 * pi) * diag(A);
end