function [MG,MGc] = MatrizG(E,B,N,Nu,d)
% Funcion que forma la matriz G (matriz de coeficientes) del Control GPC
% para procesos Multivariables MIMO
% By: Sergio Castaño
% http://controlautomaticoeducacion.com
% >> [MG,MGc] = MatrizG(E,B,N,Nu,d)
% MG  =  Matriz de Matrices (Matriz G sistema MIMO)
% MGc  =  Matriz de Matrices (Matriz G sistema MIMO en formato Celdas)
% E   =  Polinomio E de la diofantina en Celda (Se puede obtener de la
%        funcion "[E,En,F] = diophantineMIMO(A,N,dmin);" creada por mi.
% B   =  Matriz con los numeradores del sistema MIMO en formato Celda, esta
%        celda puede obtenerse de la función "[Bp,Ap,dp]=descomp(Pz);"
% N   =  Vector que contiene los horizontes de predicción de cada salida.
% Nu  =  Vector que contiene los horizontes de Control de cada Entrada.
% d   =  Matriz con los retardos de las funciones de transferencia

[s,e]=size(B); %Numero de entradas y Salidas
if e>1
    dmin=min(d'); %Almacena el retardo minimo en un vector
else
    dmin=d;
end
for i=1:s %Salida y
   for j=1:e %Entrada u
       g=conv(E{i},B{i,j});                 %Calcula polinomio g
       %Creo varias matriz G en bloques que voy a almacenar en una celda
       %para cada relación entrada salida
       G=zeros(N(i),Nu(j));                % Inicializa la matriz G
       %Verifica que retardo esta asociado a este bloque de FT para ubicar
       %los datos en la matriz un muestreo abajo (d+1)
       dk=d(i,j)-dmin(i)+1;
      
       %Mensaje de Alerta
       if dk>=N(i)
           display('Alerta!! Existen retardos efectivos del sistema MIMO mucho mayores que el Horizonte de predicción, aumente el horizonte N');
       end
       c=1;
       %Lleno la matriz G por columna, y cada que me desplazo a la
       %siguiente columna voy bajando los coeficientes de la matriz
       for k=dk:Nu(j)+dk-1
            G(k:end,c)=g(1:N(i)-k+1);         % Forma a matriz G  
            c=c+1; %Mueve la columna de la Matriz G
       end
       H{i,j}=G; %Voy almacenando en una celda Cada Matriz G
   end
end
MG= cell2mat(H); %Al finalizar convierte la celda en una Matriz
MGc=H; %Matriz G en Celda


 

