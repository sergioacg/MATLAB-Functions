function [S,Fr] = mimofilter(Pd,alfa,raio,kn)
% [S(z),Fr(z)] =  filtro_mimo(P(z),alfa,raio)
%
% Funcao para calculo do filtro de robustez Fr(z) e do preditor estável 
% S(z). 
%
% Pd:   define o processo discreto monovariavel com atraso
% alfa: define o valor dos polos desejados
% raio: define o valor maximo do modulo dos polos desejados
% nk:   Multiplicidade del numerador (Como minimo debe ser igual a los
% polos que se desea eliminar -NO Implementado)

% Estabelece a representacao do processo

Pd.variable='z';                     % Estabelece z como variavel de Pd
G=Pd;                                % Define G como o modelo rapido
set(G,'inputdelay',0)
set(G,'outputdelay',0)
set(G,'iodelay',0)
h=Pd.Ts;

[m,n]=size(Pd);

dp=Pd.iodelay;
dmin(1:m)=100;
for i=1:m
    dmin(i)=min(dp(i,:));
end

% Obtém dados para círculo do filtro Fr(z)

for i=1:m
    G2=1;
    for j=1:n
        if sum(G(i,j).num{1})~=0
            G2=minreal(G(i,j)*G2); 
        end
    end
    G2.iodelay=dmin(i);
    H(i)=G2;  
    if sum(H(i).num{1})==0
        Fr(i,i) = tf(1,1,h);
    else
        Fr(i,i) = minreal(filtro_siso(H(i),alfa,raio,kn)); 
    end
%     Fr(i,i) = tf(1,1,h); 
end
Lo=dp-diag(dmin)*ones(m,n);
G.iodelay=Lo;
% S=(ss(G)-ss(Fr)*ss(Pd));
S=minreal((G)-(Fr)*(Pd));

%% Validación de los Filtros
DG=round(dcgain(Fr)*10000);
if DG == eye(m)*10000
    disp('Fr(z) Static Gain OK')
else
    disp('Fr(z) Static Gain Wrong')
end

if pole(S) < 1.0
    disp('S(z) Stable')
else
    disp('S(z) Unstable')
end

