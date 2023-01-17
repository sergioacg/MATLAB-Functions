function [Rob]=plot_Fr_robutnessMIMO(w0,Cd,God,Fr,W1,W2,Ts)
%Grafica o indice de robustez de um sistema MIMO para o Calculo do FILTRO
%de robustez da Estrutura do Preditor de SMITH Filtrado
%  [Rob]=plot_Fr_robutnessMIMO(w0,Cd,God,Fr,W1,W2,Ts)
% ***************************
% Rob = Indice de Robustez
% w0  = Frequencia inicial
% Cd  = Controle discreto que estabiliza God 
% God = Modelo Rápido da planta
% Fr  = Filtro de Robustez
% W1, W2 = Matrices de transferencia estáveis que caracterizam a
% perturbação
% Ts = Periodo de Amostragem

w=logspace(log10(w0),log10(3.14/Ts),2000);   % Faixa de frequencia

M0=ss(Cd)/(ss(eye(size(Cd)))+ss(God)*ss(Cd));
% M0=Cd*inv(eye(size(Cd))+God*Cd);

%Indice de Robustez
Rob=1./(max_sv(sigma(M0,w)).*max_sv(sigma(W1,w)).*max_sv(sigma(W2,w)));

figure
loglog(w,Rob,'-','color',[0 0.4 0.7],'linewidth',3);
grid;

% axis([w0 3.14/Ts 10^-1 3])
hold on
loglog(w,max_sv(sigma(Fr,w)),'--','linewidth',1);

h=legend('1/($\bar{\sigma}(\mathbf{M_0})\bar{\sigma}(\mathbf{W_1})\bar{\sigma}(\mathbf{W_2}))$',...
    '$\bar{\sigma}(\mathbf{F_r})$','Location','best');

set(h,'interpreter','latex');