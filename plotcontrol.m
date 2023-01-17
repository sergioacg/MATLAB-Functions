function [] = plotcontrol(y,r,u,T,nit,varargin)
% Função que grafica respostas de controle em 2 subplot, no primero se
% apresenta a resposta à referência e no segundo a ação de controle
% [] = plotcontrol(y,r,u,T,nit)
% onde y é a matriz com todos os dados das variáveis, r é a matriz com
% todos os dados da referência, u é a matriz com todos os dados das ações
% de controle, T é o periodo de amostragem, nit é o número de iterações
%
% [] = plotcontrol(y,r,u,T,nit,titulo,eX,eY,legenda Y, legenda U,tamanho letra, tamanho de linha)
%
% Os parâmetros adicionais pode ser desabilitados colocando zero. Titulo, 
% eX:xlabel, eY: ylabel ingresado como celda {'saída','entrada'}, legenda debe
% ser ingressada em celda
% _________________________________________________________________________
% Exemplo de uso, para sistema MIMO 2x2
% >>Y=[y1;y2];
% >>r=[r1;r2];
% >>u=[u1;u2];
% >>nit=200;
% >>Tm=0.5;
% >>plotcontrol(Y,r,u,Ts,nit,'Control Process','time(h)',{'Nivel','flow'},...
%   {'r_1','r_2','y_1','y_2'},{'u_1','u_2'},15,4)
% _________________________________________________________________________
%
% by: Sergio Castaño
% http://controlautomaticoeducacion.com/
% 2017 - Rio de Janeiro

ni = nargin;
%Variaveis Default
Titulo=0;
eX=0;
eY{1}=0;
legendaY{1}=0;
legendaU{1}=0;
TL=18;
Tlin=2;
 if ni == 6
    Titulo=varargin{1};
 end
 if ni == 7
    Titulo=varargin{1};
    eX=varargin{2};
 end
 if ni == 8
    Titulo=varargin{1};
    eX=varargin{2};
    eY=varargin{3};
 end
 if ni == 9
    Titulo=varargin{1};
    eX=varargin{2};
    eY=varargin{3};
    legendaY=varargin{4};
 end
 if ni == 10
    Titulo=varargin{1};
    eX=varargin{2};
    eY=varargin{3};
    legendaY=varargin{4};
    legendaU=varargin{5};
 end
 if ni == 11
    Titulo=varargin{1};
    eX=varargin{2};
    eY=varargin{3};
    legendaY=varargin{4};
    legendaU=varargin{5};
    TL=varargin{6};
 end
 if ni == 12
    Titulo=varargin{1};
    eX=varargin{2};
    eY=varargin{3};
    legendaY=varargin{4};
    legendaU=varargin{5};
    TL=varargin{6};
    Tlin=varargin{7};
 end
 if ni > 12
    error('Muitos parâmetros de entrada escreva >>help plotcontrol')
 end
 
%Converte o periodo de amostragem em tempo
t = T:T:(nit)*T;


Lr=size(r);
nR=min(Lr); %Quantidade de referencias para cada variavel

%Asegura que o vetor referencia seja vetor coluna
if Lr(1)~=nR
    r=r';
end
for j=1:nR
    %Procura o numero de Setpoints
    ref(1)=r(1,1);n=2;
    tref(1)=1;
    for i=2:nit
        if r(j,i)~=r(j,i-1)
            ref(n)=r(j,i);
            tref(n)=i;
            n=n+1;
        end
    end
   % [ref,tref]=unique(r(j,:));

    tesc=[];
    ref1=[];
    for i=1:length(tref)
       tesc=[tesc tref(i) tref(i)]; 
       ref1=[ref1 ref(i) ref(i)]; 
    end
    tesc=tesc*T; %Multiplica pelo periodo de amostragem o tempo do degrau
    hold on
    subplot(2,1,1),plot([0 tesc nit*T],[r(1) r(1) ref1],'--','Linewidth',Tlin)
end
hold on
subplot(2,1,1),plot(t,y,'-','Linewidth',Tlin)
if eX==0
    xlabel('Time (s)');
else
    xlabel(eX);
end

if eY{1}==0
    ylabel('Output');
else
    ylabel(eY{1});
end

if Titulo~=0
    title(Titulo,'fontsize',TL)
end

if legendaY{1}~=0
    legend(legendaY,'Location','NorthWest')
end

grid on;


[tst,ust] = stairs(t,u);
subplot(2,1,2),plot(tst,ust,'Linewidth',Tlin)
if eX==0
    xlabel('Time (s)');
else
    xlabel(eX);
end

if eY{1}==0
    ylabel('Control Action');
else
    ylabel(eY{2});
end
if legendaU{1}~=0
    legend(legendaU,'Location','NorthWest')
end
grid on;
end