k = linspace(-3 * pi / 2, 3 * pi / 2, 1000);
[KX, KY] = meshgrid(k);
E_k = sqrt(3 + 4 * cos(KX / 2) .* cos(KY * sqrt(3) / 2) + 2 * cos(KX));
surf(KX, KY, E_k, 'EdgeColor', 'none');
hold on;
surf(KX, KY, -E_k, 'EdgeColor', 'none');