function [R,S,T,Kc,ti,td] = RSTController(ftz,Tss,ep,MF)
%Função que calcula o controlador RST, retornando os 3 filtros do
%controlador e retornando os parametros de um controle PID emascarado a
%partir do controle RST (só sem a ftz é de primeira ou segunda ordem)
% [R,S,T,Kc,ti,td] = RSTController(ftz,Tss,ep,MF)
% R   =  Filtro R
% S   =  Filtro S
% T   =  Filtro T
% Kc  =  Parametro Kc de PID
% ti  =  Parametro ti de PID
% td  =  Parametro td de PID
% --------------------------------------------------------------
% ftz = Função de transferência discreta
% Tss = Tempo de acomodação desejado
% ep  = Fator de amortecimento desejado
% MF  = Grafica a resposta em malha fechada do controlador
%       1 - Grafica
%       0 - Não Grafica
% --------------------------------------------------------------
% By Sergio Castaño
% http://controlautomaticoeducacion.com
% Rio de Janeiro - Brasil - 2017

Ts=ftz.Ts;
%Alocaçao de polos por condições de disenho.
wn=4/(ep*Tss);               %
%Polos conjugados
za=exp(-ep*wn*Ts);
th=57.3*wn*Ts*sqrt(1-ep^2);
polos=za*[cosd(th)+i*sind(th),cosd(th)-i*sind(th)];

[B,A]=tfdata(ftz,'v');
nb=length(B);                   %Ordem do numerador
na=length(A)-1;                 %Ordem do Denominador
nr=nb-1;                        %Ordem do polinomio R
d=ftz.iodelay;

%Calcula Matriz Sylvestre
M=sylvestre(B,A,d);
sM=size(M);
% Polinomio desejado, com polo insignificante igual a zero
Am=poly([polos zeros(1,sM(1)-3)]);

P=Am';
X=inv(M)*P;

R=X(1:nr)';                 %Polinomio R
S=X(nr+1:end)';            %Polinomio S
T=sum(S);                 %Polinomio T 

%Controle PI
if na==1
    ti=(S(1)*Ts-S(2)*Ts)/(2*S(1)+2*S(2));
    Kc=(2*S(1)*ti)/(2*ti+Ts);
    td=0;
end
%Controle PID
if na==2
    alp=S(2)+2*S(3);
    ti=(S(1)*Ts-S(3)*Ts-alp*Ts)/(2*alp-2*S(3)+2*S(1));
    Kc=(2*ti*alp)/(Ts-2*ti);
    td=(S(3)*Ts)/Kc;
end
%Se maior, nao calcula ninhum PID
if na>2
    Kc=1;ti=0;td=0;
end
    
if MF==1
    FR=tf(1,conv(R,[1 -1]),Ts);
    FS=tf(S,1,Ts);
    FT=tf(T,1,Ts);
    MF1=feedback(series(FR,ftz),FS);
    MF2=series(FT,MF1);
    figure;step(MF2);
    
end
end