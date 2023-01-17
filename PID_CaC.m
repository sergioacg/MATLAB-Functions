function [C,Kc,ti,td] = PID_CaC(varargin)
% Controlador P,PI,PID por Cohen & Coon 
% [C,Kc,ti,td] = PID_CaC(P,Controller,MF)
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
 
 [~,p,k]=zpkdata(P);
k=-k/cell2mat(p);
[nG,dG]=tfdata(P,'v');
L=P.iodelay;
tau=-1/cell2mat(p);


if strcmp(Controller,'P')
        Kc=tau/(k*L)*(1+L/(3*tau));
        Kc=Kc/type;
        ti=0; td=0;
        C=tf(Kc,1);
end
 if strcmp(Controller,'PI')
        Kc=tau/(k*L)*(0.9+L/(12*tau));
        Kc=Kc/type; 
        ti=L*(30+3*(L/tau))/(9+20*(L/tau)); 
        td=0;
        C=tf(Kc*[ti*td ti 1],[ti 0]);
 end
 if strcmp(Controller,'PID')
        Kc=tau/(k*L)*((16*tau+3*L)/(12*tau));
        Kc=Kc/type; 
        ti=L*(32+6*(L/tau))/(13+8*(L/tau)); 
        td=(4*L)/(11+2*(L/tau));
        
        C=tf(Kc*[ti*td ti 1],[alfa*td*ti ti 0]);
 end
 
 if MF==1
     step((C*P)/(1+C*P));
 end
    
end