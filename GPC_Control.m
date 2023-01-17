function [K,Qd,Ql,na,Hp,up,duM,S,G,H,I,Triang,T,InUmax,InUmin,u_max,u_min,y_max,y_min,M,Bt,A,dp] = GPC_Control(Pz,N,Nu,delta,lambda,varargin)
% Esta función calcula todos los parametros y matrices necesarias para
% ejecutar un algoritmo de control predictivo GPC. Su ejecución básica
% puede ser llamada de la siguiente forma para un sistema sin restricciones:
% [K,Qd,Ql,na,Hp,up,duM,S] = GPC_Control(Pz,N,Nu,delta,lambda);
%
% ---------- PARAMETROS DE SALIDA -----------------------------
% K  =  Primeras filas de la matriz de control del GPC
% Qd = Matriz de pesos diagonal del seguimiento de referencia
% Ql = Matriz de pesos diagonal de la supreción de control
% na = tamaño del Polinomio A común de cada salida del proceso MIMO
% Hp = Matriz con los coeficientes de control pasados
% up = Inicializacion Vector de las acciones de control pasado
% duM= Vector con los tamaños de cada control pasado de up
% S  = Matriz con Coeficientes de las salidas pasadas
%
% ---------- PARAMETROS DE ENTRADA -----------------------------
% Pz      = Matriz de funcion de transferencia discreta MIMO del proceso
% N       = Horizonte de predicción  (vector)
% Nu      = Horizonte de control (vector)
% delta   = Ponderación del seguimiento de referencia
% lambda  = Ponderación del incremento de control
%
%________________________________________________________________
%
% Adicionalmente, la función acepta parametros EXTRAS para transformar cada
% parametro a un problema de DTC-GPC o simplemente para involucrar las
% matrices necesarias para resolver el problema de optimización con
% restricciones, de esa forma, la función completa, puede ser llamada de la
% siguiente forma:
%
% [K,Qd,Ql,na,Hp,up,duM,S,G,H,I,Triang,T,InUmax,InUmin,u_max,u_min,y_max,y_min] = GPC_Control(Pz,N,Nu,delta,lambda,DTC,rest,InUmx,InUmn,Umx,Umn,Ymx,Ymn);
%
% La adición de estos parametros de salida, van relacionados principalmente
% a la conformación de los vectores "a" y "b" del quadprog, por ejemplo:
% a=[I; - I;Triang; -Triang;G; -G];
% b=[InUmax; -InUmin;u_max-T.*ub; T.*ub-u_min;y_max-yf; yf-y_min];
%          
% ---------- PARAMETROS DE SALIDA -----------------------------
% G       =Matriz de los coeficientes al escalón del sistema
% H       = G'*Qd*G+Ql;
% I       = Matriz Identidad
% Triang  = Matriz Triangular Inferior
% T       = Vector lleno de unos
% InUmax  = Incrementos de control máximo
% InUmin  = Incrementos de control mínimo
% u_max   =  control máximo
% u_min   =  control mínimo
% y_max   = limite máximo en las salidas
% y_min   = limite mínimo en las salidas
%
% ---------- PARAMETROS DE ENTRADA -----------------------------
% DTC     =  0-> GPC   1-> DTC-GPC
% rest    =  0 -> Sin Restricción,  1 -> CON Restricción
% InUmx   = Incrementos de control máximo para cada variable
% InUmn   = Incrementos de control mínimo para cada variable
% Umx     =  control máximo para cada variable
% Umn     =  control mínimo para cada variable
% Ymx     = limite máximo en las salidas para cada variable
% Ymn     = limite mínimo en las salidas para cada variable
%
%
% by Sergio Andres Castaño Giraldo
% https://controlautomaticoeducacion.com/
%
%



[my,ny]=size(Pz);
ni = nargin;
parOk=0;
% K=0;
DTC=0;
rest=0;
I=0;
Triang=0;
T=0;
InUmax=0;InUmin=0;u_max=0;u_min=0;y_max=0;y_min=0;
nq=0;

%% Pregunta si ingresa opciones extras como restricciones o el DTC-GPC
 if ni == 6
     DTC=varargin{1};
 elseif ni==7
     DTC=varargin{1};
     rest=varargin{2};
     InUmx=inf*ones(1,ny);
     InUmn=-inf*ones(1,ny);
     Umx=inf*ones(1,ny);
     Umn=-inf*ones(1,ny);
     Ymx=inf*ones(1,my);
     Ymn=-inf*ones(1,my);
     nq=0;
elseif ni==8
     DTC=varargin{1};
     rest=varargin{2};
     InUmx=varargin{3};
     InUmn=-inf*ones(1,ny);
     Umx=inf*ones(1,ny);
     Umn=-inf*ones(1,ny);
     Ymx=inf*ones(1,my);
     Ymn=-inf*ones(1,my);
     nq=0;
elseif ni==9
     DTC=varargin{1};
     rest=varargin{2};
     InUmx=varargin{3};
     InUmn=varargin{4};
     Umx=inf*ones(1,ny);
     Umn=-inf*ones(1,ny);
     Ymx=inf*ones(1,my);
     Ymn=-inf*ones(1,my);
     nq=0;
 elseif ni==10
     DTC=varargin{1};
     rest=varargin{2};
     InUmx=varargin{3};
     InUmn=varargin{4};
     Umx=varargin{5};
     Umn=-inf*ones(1,ny);
     Ymx=inf*ones(1,my);
     Ymn=-inf*ones(1,my);
     nq=0;
 elseif ni==11
     DTC=varargin{1};
     rest=varargin{2};
     InUmx=varargin{3};
     InUmn=varargin{4};
     Umx=varargin{5};
     Umn=varargin{6};
     Ymx=inf*ones(1,my);
     Ymn=-inf*ones(1,my);
     nq=0;
  elseif ni==12
     DTC=varargin{1};
     rest=varargin{2};
     InUmx=varargin{3};
     InUmn=varargin{4};
     Umx=varargin{5};
     Umn=varargin{6};
     Ymx=varargin{7};
     Ymn=-inf*ones(1,my);
     nq=0;
 elseif ni==13
     DTC=varargin{1};
     rest=varargin{2};
     InUmx=varargin{3};
     InUmn=varargin{4};
     Umx=varargin{5};
     Umn=varargin{6};
     Ymx=varargin{7};
     Ymn=varargin{8};
     nq=0;
 elseif ni==14
     DTC=varargin{1};
     rest=varargin{2};
     InUmx=varargin{3};
     InUmn=varargin{4};
     Umx=varargin{5};
     Umn=varargin{6};
     Ymx=varargin{7};
     Ymn=varargin{8};
     nq=varargin{9};
 end

%% Validación
if length(N)~= my
    disp('The prediction horizon (N) must be a vector of equal size as the number of system outputs (Pz)');
elseif length(Nu)~= ny-nq
    disp('The control horizon (Nu) must be a vector of equal size as the number of system inputs (Pz)');
elseif length(delta)~= my
    disp('The Tuning weight for jth plant output (delta) must be a vector of equal size as the number of system outputs (Pz)');
elseif length(lambda)~= ny-nq
    disp('The Tuning weight for jth MV movement (lambda) must be a vector of equal size as the number of system inputs (Pz)');
else
    parOk=1;
end

%% Algoritmo de Control GPC
if parOk==1

    %Mensagem mostrando o tipo de controle seleccionado
% if DTC==1
%     disp('DTC-GPC Control selected')
% else
%     disp('GPC Control selected')
% end

[Bp,Ap,dp]=descompMPC(Pz,ny+1);     %Descompone num, den e atraso de Pz em celdas

%Encuentro cual es el retardo minimo en mi función de transferencia
dmin(1:my)=100;
for i=1:my
    dmin(i)=min(dp(i,:));
end

%% Modelo Rápido
% dreal=Pz.iodelay;
% Gnz=Pz;
% Gnz.iodelay=dreal-diag(dmin)*ones(my,ny);
dnz=dp-diag(dmin)*ones(my,ny);

%% Parametros de sintonia del GPC
% N1=[];N2=[];
% for i=1:my
%     N1=[N1 dmin(i)+1];               %Horizonte Inicial
%     N2=[N2 dmin(i)+N(i)];          %Horizonte final
% end

%Matrices en bloque de los parametros de poderación
Ql=[];
for i=1:ny-nq
    Ql=blkdiag(Ql,lambda(i)*eye(Nu(i)));  %(lambda -> Acción de Control)
end
Ql=sparse(Ql);
Qd=[];
for i=1:my
    Qd=blkdiag(Qd,delta(i)*eye(N(i)));  %(delta  -> Seguimiento de Referencia)
end
Qd=sparse(Qd);
%% Calculo de la ecuacion Diofantina
%Se obtiene la matriz B y A (Numerador y denominador sistema MIMO)
% la matriz A es el minimo común denominador del sistema
[Bt,A,na,nb] = BA_MIMO(Bp,Ap);

%Calculo de las Diofantinas
if DTC==1
    [E,En,F] = diophantineMIMO(A,N,0*dmin); %DTC-GPC
else
    [E,En,F] = diophantineMIMO(A,N,dmin); %GPC
end


%Matriz bloque S con los coeficientes de la respuesta libre (polinomio F)
S=[];
for i=1:my
    S=blkdiag(S,F{i}(1:N(i),1:end)); 
end

%% Matriz de la Respuesta Forzada G
% [G] = MatG(Pz,N,Nu,dp);
if nq==0
    [G] = MatG(Pz,N,Nu,dp);
else
    [G,Gq,MG] = MatGQ(Pz,N,[Nu ones(1,nq)],dp,ny-nq+1);
end


%% Sistema Irrestrito
H=G'*Qd*G+Ql;
M=((H+H')/2)\G'*Qd;               %Ganancia M
K(1,:)=M(1,:);                       %Tomo la primera columna unicamente (para control u1)
for i=1:ny-nq-1
    K(i+1,:)=M(sum(Nu(1:i))+1,:);    %Tomo valores de M desde [N(1)+1] una muestra despues del primer 
                                     %horizonte de control (para control u2)
end

%% Determino el Vector con los controles pasados utilizando la funcion:
if DTC==1
    uG = deltaUFree(Bt,En,N,dnz); %DTC-GPC
    duM=max(nb+dnz); %DTC-GPC
else
    uG = deltaUFree(Bt,En,N,dp); %GPC
    duM=max(nb+dp); %GPC
end
Hp = cell2mat2(uG);   %Polinomio con controles Pasados
up=zeros(sum(duM),1); %Vector Controles Pasados

if rest==1
     I=eye(sum(Nu)); %Matriz identidad 
     % Restriccion no Sinal de Controle e no Incremento de Controle -----------------%
     Triang=[];  
     T=ones(sum(Nu),1);
     j=1;
    for i=1:ny-nq
         InUmax(j:j+Nu(i)-1,1)=InUmx(i)*ones(Nu(i),1); %Incremento maximo
         InUmin(j:j+Nu(i)-1,1)=InUmn(i)*ones(Nu(i),1); %Incremento maximo
         u_max(j:j+Nu(i)-1,1)=Umx(i)*ones(Nu(i),1);  
         u_min(j:j+Nu(i)-1,1)=Umn(i)*ones(Nu(i),1);
         j=sum(Nu(1:i))+1;
         Triang=blkdiag(Triang,tril(ones(Nu(i))));
     end

    %Restricao de Saída
     j=1;
     for i=1:my
         y_max(j:j-1+N(i),1)=Ymx(i)*ones(N(i),1);  
         y_min(j:j-1+N(i),1)=Ymn(i)*ones(N(i),1);
         j=sum(N(1:i))+1;
     end

    % I=sparse(I);
    Triang=sparse(Triang);
     
end

end