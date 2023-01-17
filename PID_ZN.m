function [C,Kc,ti,td] = PID_ZN(varargin)
% Controlador P,PI,PID por Ziegler & Nichols malha aberta
% [C,Kc,ti,td] = PID_ZN(P,Controller,type,MF)
% C   =  Função de transferencia do controlador
% Kc  =  Ação Proporcional
% ti  =  Tempo integral
% td  =  Tempo derivativo
% P   =  Função de Transferencia do Processo
% Controller= Selecciona o tipo de controle 'P','PI' (default),'PID' 
% type = 1(default)- Controlador Normal, 2 - controlador Lento
% MF   =  Grafico do controlador em Malha Fechada (1-graficar, 0-Nao graficar)
% ______________________________________________________________________
% by: Sergio Castaño
% http://controlautomaticoeducacion.com/
%

ni = nargin;
no = nargout;
titlewin='PID Ultimate Gain Ziegler and Nichols';
 if ni ==0
     error('Sem parâmetros escreva >>help PID_Ku')
 end   
 
if ni == 1
    P=varargin{1};
    Controller='PI';
    type=1;
    MF=0;
    alfa=1; %Filtro do PID
 end
 
 if ni == 2
    P=varargin{1};
    Controller=varargin{2};
    type=1;
    MF=0;
    alfa=1; %Filtro do PID
 end
 
 if ni == 3
    P=varargin{1};
    Controller=varargin{2};
    type=varargin{3};
    MF=0;
    alfa=1; %Filtro do PID
 end
 
 if ni == 4
    P=varargin{1};
    Controller=varargin{2};
    type=varargin{3};
    MF=varargin{4};
    alfa=1; %Filtro do PID
 end
 
 if ni == 5
    P=varargin{1};
    Controller=varargin{2};
    type=varargin{3};
    MF=varargin{4};
    alfa=varargin{5}; %Filtro do PID
 end
 
 if ni > 6
    error('Muitos parâmetros de entrada escreva >>help PID_Ku')
 end
 
k=dcgain(P);
[nG,dG]=tfdata(P,'v');
L=P.iodelay;
tau=1/(abs(max(roots(dG)))); %Toma o valor do polo dominante
if(L==0)
    L=tau/1000;
end

if strcmp(Controller,'P')
        Kc=tau/(k*L);
        Kc=Kc/type;
        ti=0; td=0;
        C=tf(Kc,1);
end
 if strcmp(Controller,'PI')
        Kc=(0.9*tau)/(k*L);
        Kc=Kc/type; 
        ti=3.33*L; td=0;
        C=tf(Kc*[ti*td ti 1],[ti 0]);
 end
 if strcmp(Controller,'PID')
        Kc=(1.2*tau)/(k*L);
        Kc=Kc/type;  
        ti=2*L; td=0.5*L;
        alfa=0; %Filtro do PID
        C=tf(Kc*[ti*td ti 1],[alfa*td*ti ti 0]);
 end
 
 if MF==1
     step((C*P)/(1+C*P));
 end
    
end