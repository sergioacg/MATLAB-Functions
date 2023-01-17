function [C,Kc,ti,td,Ku,Tu] = PID_Ku(varargin)
% Controlador P,PI,PID por Ziegler & Nichols por ganho ultimo
% Os parâmetros Ku e Tu se poden evaluar pelo diagrama de Bode do sistema
% continuo em malha  aberta
% [C,Kc,ti,td,Ku,Tu] = PID_Ku(P,Controller,MF)
% C   =  Função de transferencia do controlador
% Kc  =  Ação Proporcional
% ti  =  Tempo integral
% td  =  Tempo derivativo
% Ku  =  Ganho Ultimo
% Tu  =  Periodo do Ganho Ultimo
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
 
[Ku,~,Wcg1,~] = margin(P);
Tu=2*pi/Wcg1;
if strcmp(Controller,'P')
        Kc=0.5*Ku/type; ti=0; td=0;
        C=tf(Kc,1);
end
 if strcmp(Controller,'PI')
        Kc=(0.45*Ku)/type; ti=Tu/1.2; td=0;
        C=tf(Kc*[ti*td ti 1],[ti 0]);
 end
 if strcmp(Controller,'PID')
        Kc=0.6*Ku/type; ti=Tu/2; td=Tu/8;
        alfa=1; %Filtro do PID
        C=tf(Kc*[ti*td ti 1],[alfa*td*ti ti 0]);
 end
 
 if MF==1
     step((C*P)/(1+C*P));
 end
    
end