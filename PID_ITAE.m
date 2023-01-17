function [C,Kc,ti,td] = PID_ITAE(varargin)
% Controlador P,PI,PID por ITAE para sistemas de primer ordem com atraso
% [C,Kc,ti,td] = PID_ITAE(P,Controller,MF)
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
        a=0.94;
        b=-1.084;
        Kc=(a/k)*(L/tau)^b;
        Kc=Kc/type;
        ti=0; td=0;
        C=tf(Kc,1);
end
 if strcmp(Controller,'PI')
        a=0.586;
        b=-0.916;
        Kc=(a/k)*(L/tau)^b;
        Kc=Kc/type;
        a=1.03;
        b=-0.165;
        ti=tau/(a+b*(L/tau));
        td=0;
        C=tf(Kc*[ti*td ti 1],[ti 0]);
 end
 if strcmp(Controller,'PID')     
        a=1.357;
        b=-0.947;
        Kc=(a/k)*(L/tau)^b;
        Kc=Kc/type;
        a=0.842;
        b=0.738;
        ti=(tau/a)*(L/tau)^b;
        a=0.381;
        b=0.995;
        td=a*tau*(L/tau)^b;
        alfa=1; %Filtro do PID
        C=tf(Kc*[ti*td ti 1],[alfa*td*ti ti 0]);
 end
 
 if MF==1
     step((C*P)/(1+C*P));
 end
    
end