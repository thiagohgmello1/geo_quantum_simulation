function integ = gauss_int_1d_par(func, number_gauss_points, number_iter, x_min, x_max)
%gauss_int_1d determines Gauss-Lagrange integral of function func using
%parallel programing

x_len = number_iter + 1;
x = linspace(x_min, x_max, x_len);
[ti, Ai] = gauss_points(number_gauss_points);

integ = 0;
parfor j=1:(x_len - 1)
    a = x(j);
    b = x(j + 1);
    A = (b - a) / 2;
    B = (a + b) / 2;
    jac = (b - a) / 2;
    for i=1:number_gauss_points
        x_ti = A * ti(i) + B;
        F_ti = func(x_ti) * jac;
        integ = integ + Ai(i) * F_ti;
    end
end

end

