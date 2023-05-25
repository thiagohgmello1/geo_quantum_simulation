E = 0;

H0 = alpha{1};
H1 = beta{1};
H_1 = H1';
N = length(H0);

S0 = eye(N);
S1 = zeros(N);
S_1 = S1';

K0 = H0 - E * S0;
K1 = H1 - E * S1;
K_1 = H_1 - E * S_1;

IN = eye(N);
ZN = zeros(N);

A = [-K0, -K_1; IN, ZN];
B = [K1, ZN; ZN, IN];

[C_kp,lambda] = eig(A,B);
kp = log(diag(lambda)) / 1i;
lambda_aux = ones(2 * N) * lambda;
exp_aux = [sqrt(lambda_aux(1:N,:)); 1 ./ (sqrt(lambda_aux(N+1:2*N,:)))];
c_kp_aux = C_kp ./ exp_aux;
c_kp = [];

for j=1:2*N
    aux = c_kp_aux(1:N, j);
    if any(isnan(aux))
        c_kp(:, j) = c_kp_aux(N+1:2*N, j);
    else
        c_kp(:, j) = c_kp_aux(1:N, j);
    end
end

v_kp = [];
lbd = diag(lambda);
for i=1:length(diag(lambda))
    v_kp(i) = 1i * (c_kp(:,i)' * (K1 * lbd(i) - K_1 / lbd(i)) * c_kp(:,i)) / (c_kp(:,i)' * c_kp(:,i));
end










