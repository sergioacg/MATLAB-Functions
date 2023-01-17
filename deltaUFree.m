% By:  Sergio Andres Castaño Giraldo
% http://controlautomaticoeducacion.com/
% ______________________________________________________________________
% Funcion que permite obtener la matriz con los controles pasados de un
% sistema MIMO (Para GPC)
% uG = MIMO_PastCon(B,En,N,dp)
% uG  =  Matriz con controles pasados
% B   =  Polinomio B modelo CARIMA (CELDA)
% En  =  Diofantina E obtenida de la funcion (diophantineMIMO)
% N   =  Horizonte de Prediccion
% dp  =  Matriz con los retardos del sistema
%
function uG = deltaUFree(B,En,N,dp)
    dmin=min(dp'); %Almacena el retardo minimo en un vector
    [ny,nu]=size(B);
    for m=1:ny %Contador de la Salida
        for n=1:nu %Contador de la Entrada
            %Se crea una matriz que contenga los incrementos de control
            %pasados para cada relación entrada salida, es decir se van a
            %crear bloques de matrices y al final puede condensarse todo en
            %una unica matriz
            
            %La matriz de controles pasados depende unicamente del tamaño
            %del polinomio del numerador (B) y del retardo que tenga el
            %sistema, de esa forma podemos determinar inicialmente cuales
            %serán las dimensiones de dicha matriz, teniendo en
            %consideración que el numero de filas viene dado por el
            %horizonte de predicción de cada salida. El numero de columnas
            %viene dado por el tamaño de B  y el retardo menos uno
            cp=(dp(m,n))+length(B{m,n})-1; %Numero de datos en el pasado
            if isempty(cp) || cp<1
                cp=1;
            end
            uG1=zeros(N(m),cp); %(Nxcp)Vector de controles pasados (Pertenece a la respuesta libre)
            
            %Los datos de la matriz de controles pasados se obtienen con el
            %producto del polinomio B con cada uno de los polinomios E (diofantina)
            for i=1:N(m)
                aux=conv(En{m}(i,:),B{m,n});
                %El resultado almacenado en aux va a dar vectores con
                %varios ceros a la derecha a escepción de la ultima
                %interacción del for actual, la idea entonces va a ser
                %eliminar dichos ceros
                BE=[];
                for j=length(aux):-1:1
                   if aux(j)~=0
                       BE=[aux(j) BE];
                   end
                end
                %Despues de eliminar dichos ceros, se procede a llenar la
                %matriz uG1 de controles pasados desde la ultima columna
                %hasta la primera. Los datos de dicha matriz se encuentran
                %en el vector BE, pero solo debo tomar los datos
                %relacionados con el pasado, estos datos son los que están
                %de atras para adelante en BE hasta la longitud "cp"
                lBE=length(BE); %Tamaño de BE
                if lBE<cp
                    uG1(i,:)=[zeros(1,cp-lBE) BE];
                else 
                    uG1(i,:)=BE(end-cp+1:end);
                end
                
            end
            uG{m,n}=uG1; %Voy almacenando en una celda Cada Matriz uG1
        end
        
    end
end