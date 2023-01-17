function [MG,MGc] = MatG(Ps,N,Nu,d)

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
       %Lleno la matriz G por columna, y cada que me desplazo a la
       %siguiente columna voy bajando los coeficientes de la matriz
       for k=1:Nu(j)
            G(k:end,c)=g{i,j}(dmin(i)+2:dmin(i)+N(i)-k+2);         % Forma a matriz G  
            c=c+1; %Mueve la columna de la Matriz G
       end
       H{i,j}=G; %Voy almacenando en una celda Cada Matriz G
   end
end
MG= cell2mat(H); %Al finalizar convierte la celda en una Matriz
MGc=H; %Matriz G en Celda