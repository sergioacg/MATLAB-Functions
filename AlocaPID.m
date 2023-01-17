function [C,Kc,ti,td] = AlocaPID(varargin)
% Controlador PI,PID por Alocação de Polos
%     [C,Kc,ti,td] = AlocaPID(P,TsMA,ep,Controller,VF,MF,alfa,type)
%------- SAIDAS DA FNC -------------------------
% C   =  Função de transferencia do controlador
% Kc  =  Ação Proporcional
% ti  =  Tempo integral
% td  =  Tempo derivativo
%
%------- ENTRADAS DA FNC -------------------------
% P   =  Função de Transferencia do Processo
% TsMA=  Tempo de Acomodacao
% ep  =  Fator de amortecimento
% Controller= Selecciona o tipo de controle 
%             'PI'  - Sistema de Primer Orden (Sem Atraso domiante)
%             'PID' - Sistema de Segundo Orden (Sem Atraso domiante)
% VF  =   2 - Acomodacao 2%, 5- Acomodacao 5%
% MF   =  Grafico do controlador em Malha Fechada (1-graficar, 0-Nao graficar)
% alfa =  Filtro do controle PID parametro entre (0 e 1)
% type = 1- Controlador Normal, 2 - controlador Lento
% ______________________________________________________________________
% by: Sergio Andres Castaño Giraldo
% https://www.youtube.com/c/SergioACastañoGiraldo
% http://controlautomaticoeducacion.com/
% Em desenvolvimento ainda ......

ni = nargin;
no = nargout;
titlewin='PID Alocação de Polos';
 if ni <3
     error('Faltam parâmetros escreva >>help AlocaPID')
 end   
 
 if ni == 3
    P=varargin{1};
    TsMA=varargin{2};
    ep=varargin{3};
    Controller='PI';
    VF=5;
    type=1;
    MF=0;
    alfa=1;
 end
 
 if ni == 4
    P=varargin{1};
    TsMA=varargin{2};
    ep=varargin{3};
    Controller=varargin{4};
    VF=5;
    type=1;
    MF=0;
    alfa=1;
 end
 
 if ni == 5
    P=varargin{1};
    TsMA=varargin{2};
    ep=varargin{3};
    Controller=varargin{4};
    VF=varargin{5};
    type=1;
    MF=0;
    alfa=1;
 end
 
 if ni == 6
    P=varargin{1};
    TsMA=varargin{2};
    ep=varargin{3};
    Controller=varargin{4};
    VF=varargin{5};
    MF=varargin{6};
    type=1;
    alfa=1;
 end
 
 if ni == 7
    P=varargin{1};
    TsMA=varargin{2};
    ep=varargin{3};
    Controller=varargin{4};
    VF=varargin{5};
    MF=varargin{6};
    alfa=varargin{7};
    type=1;
 end
 
 if ni == 8
    P=varargin{1};
    TsMA=varargin{2};
    ep=varargin{3};
    Controller=varargin{4};
    VF=varargin{5};
    MF=varargin{6};
    alfa=varargin{7};
    type=varargin{8};
 end
 
 if ni > 9
    error('Muitos parâmetros de entrada escreva >>help PID_Ku')
 end

if ep<0
    ep=0.707
end

if VF~=2 && VF~=5
    VF=5
end

%Frequencia natural para tempo de estabelecimento de 5%
if ep<1 && VF==5
    Wn=3/(ep*TsMA); %Frequência Natural
end

%Frequencia natural para tempo de estabelecimento de 2%
if ep<1 && VF==2
    Wn=4/(ep*TsMA); %Frequência Natural
end

if ep>=1
    Wn=(8*ep)/TsMA; %Frequência Natural
end

k=dcgain(P);
[n,dG]=tfdata(P,'v');
L=P.iodelay;
Gp=tf(n/dG(1),dG/dG(1));
%% 


 if strcmp(Controller,'PI')
        %Calcula os Polos Desejados:
        Sd=[-ep*Wn+1i*Wn*sqrt(1-ep^2), -ep*Wn-1i*Wn*sqrt(1-ep^2)]; %Alocação de Polos
        Pds=poly(Sd);
        tau=1/(abs(max(roots(dG)))); %Toma o valor do polo dominante
        Kc=(Pds(2)*tau-1)/k;        %Calculo de Kc
        
        ti=(k*Kc)/(Pds(3)*tau);     %Calculo de ti
        td=0;
        Kc=Kc/type;
        %C=tf(Kc*[ti 1],[ti 0]);
 end
 if strcmp(Controller,'PID')
     aux=0;
     if length(dG)==2 %Se o sistema é de primer ordem
         tau=1/(abs(max(roots(dG)))); %Toma o valor do polo dominante 
         if L==0
             L=tau/1000;
         end
         if tau>L
             dG=conv(dG,[L 1]); %Aproxime o sistema para segundo ordem
             dG=dG/dG(1);
             Gp=tf(k*dG(3),dG);
         else
             disp('Atraso dominante, calculose control por cancelamento')
             ti=tau;
             td=0.5*L;
             Kc=tau/((L+tau*0.9)*k);
             
             alfa=1/(1+k*Kc*L/tau);
             aux=1;
             Kc=Kc/type;
         end
     end
     if aux==0
        %Calcula os Polos Desejados:
        Sd=[-ep*Wn+1i*Wn*sqrt(1-ep^2), -ep*Wn-1i*Wn*sqrt(1-ep^2)]; %Alocação de Polos
        p1=real(Sd(1))*20; %Polo nao dominante 10 veces longe do dominante
        Sd=[Sd p1];
        Pds=poly(Sd);
        %(c2S^2+c1S+c0)/s
        
        x0=[1 1 1 1];
        X = fsolve(@(x)parametrosPID(x,Gp,Pds,alfa),x0);
        Kc=X(1);
        Kc=Kc/type;
        ti=X(2);
        td=X(3);
     end
        
 end
    
%        C=tf(Kc*[ti*td ti 1],[ti 0]);
      C=tf(Kc*[ti*td ti 1],[alfa*td*ti ti 0]);
       
       if MF==1
           M = feedback(C*P,1); 
           step(M);
       end
       
function y = parametrosPID(x,FT,pd,alpha)

n1=FT.num{1};
d1=FT.den{1};

P=tf(n1/d1(1),d1/d1(1)); %Normaliza la FT
k=dcgain(P);%Ganho Estatico
n=k*d1(3); %Numerador
d=P.den{1};%denominador

%Definición de las variables:

kc=x(1);
ti=x(2);
td=x(3);
p1=x(4); %Polo insignificante

%Ecuaciones
f1=1/(alpha*td)+d(2)-pd(2)-p1;
f2=(d(2))/(alpha*td)+d(3)+n*kc/alpha-pd(3)-pd(2)*p1;
f3=(d(3))/(alpha*td)+n*kc/(alpha*td)-pd(4)-pd(3)*p1;
f4=n*kc/(alpha*td*ti)-pd(4)*p1;


y=[f1 f2 f3 f4];