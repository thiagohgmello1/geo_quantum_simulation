%% Compare kwant results with geometric diode software

% Load data
hamil = readmatrix('../data/hamil.csv');
hoppings0 = readmatrix('../data/hoppings0.csv');
hoppings1 = readmatrix('../data/hoppings1.csv');
pos = readmatrix('../data/pos.csv');

H_eig = eig(H);
hamil_eig = eig(hamil);

are_equal = is_close(H_eig, hamil_eig, 1e-12);
diff_lines = find(~are_equal);

%% Plots check

% Plot connections
figure();
for i=1:length(hoppings0)
    plot([hoppings0(i,1) hoppings1(i,1)], [hoppings0(i,2) hoppings1(i,2)], 'b');
    hold on;
end
hold off;

% Plot nodes
figure();
plot(pos(:,1), pos(:,2), 'r*');
hold on;
for i=1:length(pos)
    text(pos(i,1), pos(i,2), num2str(i));
end
hold off;















