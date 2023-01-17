function [MG,MQ,MMG,MGc] = MatGQ(Ps,N,Nu,d,qc)
%Calcula la matriz forzada en la presencia de dinamicas de perturbación
%dentro de la función de transferencia del modelo
%MG: Matriz forzada G (entrada - salida)
%MQ: Matriz forzada Q (Perturbación - Salida)
%MMG: Es la unión de G y Q
%MGc: Es MMG en celdas
%Ps: Función de transferencia con modelo de perturbación incluiso
%N: Horizonte de predicción
%Nu: Horizonte de control INCLUYENDO horizonte para perturbación
%d: retardos de la función de transferencia Ps
%qc: Columna donde empieza la perturbación
[s,e]=size(Ps);
Ts=Ps.Ts;
if e==1
    dmin=d;
else
    dmin=min(d'); %Almacena el retardo minimo en un vector
end
for i=1:s %Salida y
   for j=1:e %Entrada u
       g{i,j}=step(Ps(i,j),(N(i)+dmin(i))*Ts);                 %Calcula polinomio g
       %Creo varias matriz G en bloques que voy a almacenar en una celda
       %para cada relación entrada salida
       G=zeros(N(i),Nu(j));                % Inicializa la matriz G
       %Verifica que retardo esta asociado a este bloque de FT para ubicar
       %los datos en la matriz un muestreo abajo (d+1)
       dk=d(i,j)-dmin(i)+1;
      
       %Mensaje de Alerta
       if dk>=N(i)
%            display('Alerta!! Existen retardos efectivos del sistema MIMO mucho mayores que el Horizonte de predicción, aumente el horizonte N');
       end
       c=1;
       if j<qc
           v=2;
       else
           v=1;
       end
       %Lleno la matriz G por columna, y cada que me desplazo a la
       %siguiente columna voy bajando los coeficientes de la matriz
       for k=1:Nu(j)
            G(k:end,c)=g{i,j}(dmin(i)+v:dmin(i)+N(i)-k+v);         % Forma a matriz G  
            c=c+1; %Mueve la columna de la Matriz G
       end
       H{i,j}=G; %Voy almacenando en una celda Cada Matriz G
       if j>=qc
           H3{i,j-qc+1}=G; 
       else
           H2{i,j}=G;
       end
   end
end
MG= cell2mat(H2); %Al finalizar convierte la celda en una Matriz
MQ=cell2mat(H3);
MMG=cell2mat(H);
MGc=H; %Matriz G en Celda