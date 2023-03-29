clear
%Ballistic self-consistent solution
%Constants (all MKS, except energy which is in eV)
hbar=1.06e-34;
q=1.6e-19;
m=0.25*9.1e-31;
kT=0.0259;
zplus=1i*1e-12;
eps0=8.854e-12;
%inputs
a=3e-10;
t0=(hbar^2)/(2*m*(a^2)*q);
N=40;
fermi_energy=0.1;
Ec=-0.5;
gate_voltage=0;
r=5e-9;
tox=5e-9;
K=2; %Use large value of permittivity K for Laplace limit
U0=q/2/pi/a/K/eps0.*log((r+tox)/r);
%Hamiltonian matrix
n_nodes=40;
H0=(2*t0*diag(ones(1,n_nodes)))-(t0*diag(ones(1,n_nodes-1),1))-(t0*diag(ones(1,n_nodes-1),-1));
%Energy grid
n_energy=401;
E=linspace(-0.5,0.3,n_energy);
dE=E(2)-E(1);
I0=(q^2)/hbar/2/pi;
%Bias
n_voltages=41;
Voltages=linspace(0,0.4,n_voltages);
n0=0;
UL=-gate_voltage*ones(n_nodes,1);
U=UL;
for i=1:n_voltages
    drain_voltage=Voltages(i);
    ec_pot_1=fermi_energy;
    ec_pot_2=fermi_energy-drain_voltage;
    sigma_1=zeros(n_nodes);
    sigma_2=zeros(n_nodes);
    epsilon=1;
    while (epsilon>0.001)
        rho=0;
        for k=1:n_energy
            fermi_1=1/(1+exp((E(k)-ec_pot_1)/kT));
            fermi_2=1/(1+exp((E(k)-ec_pot_2)/kT));

            cka1=1-(E(k)+zplus-Ec)/2/t0;
            ka1=acos(cka1);
            sigma_1(1,1)=-t0*exp(1i*ka1);
            gamma_1=1i*(sigma_1-sigma_1');
            cka2=1-(E(k)+zplus-Ec+drain_voltage)/2/t0;
            ka2=acos(cka2);
            sigma_2(N,N)=-t0*exp(1i*ka2);
            gamma_2=1i*(sigma_2-sigma_2');
            sigma_in_1=fermi_1*gamma_1;
            sigma_in_2=fermi_2*gamma_2;

            G_r=inv((E(k)+zplus)*eye(N)-H0-diag(U)-sigma_1-sigma_2);
            A=1i*(G_r-G_r');
            Gn=G_r*(sigma_in_1+sigma_in_2)*G_r';
            rho=rho+dE/2/pi*Gn;
            T(k)=trace(gamma_1*G_r*gamma_2*G_r');
            I1(k)=real(trace(sigma_in_1*A)-trace(gamma_1*Gn));
            I2(k)=-real(trace(sigma_in_2*A)-trace(gamma_2*Gn));
        end
        n=real(diag(rho));
        Unew=UL+(U0*(n-n0));
        dU=Unew-U;
        epsilon=max(abs(dU));
        U=U+0.25*dU;
        if drain_voltage==0
            n0=n;
            epsilon=0;
        end
    end
    ID1=2*I0*dE*sum(I1);
    ID2=2*I0*dE*sum(I2); %2 for spin
    I(i)=ID1;
end
IonL=I0*fermi_energy;

hold on
h=plot(Voltages,I,'b');
h=plot(Voltages,IonL*ones(n_voltages,1),'bx');
set(h,'linewidth',[2.0])
set(gca,'Fontsize',[24])
grid on
xlabel('Voltage ( V ) -->')
ylabel('Current ( A ) -->')