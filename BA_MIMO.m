% By:  Sergio Andres Castaño Giraldo
% http://controlautomaticoeducacion.com/
% ______________________________________________________________________
% Función encargada de obtener la matriz B (numerador MIMO) y la matriz A
% (denominador MIMO) para el calculo de las difantinas en el MPC. Como
% parametros de entrada debe ser ingresado una celda (Bn) que contenga
% todos los numeradores de la planta y una celda (An) que contenga todos
% los denominadores de la planta. Una forma rápida de obtener esas celdas
% es utilizando la funcion "descomp"
% [B,A] = BA_MIMO(Bn,An)
% B    = Matriz B
% A    = Matriz A (minimo común Multiplo)
% Bn   = Matriz CELDA que contiene los numeradores de la FT MIMO
% An   = Matriz CELDA que contiene los denominadores de la FT MIMO
function[B,A,na,nb] = BA_MIMO(Bn,An)
  [p,m]=size(An); %Numero de salidas(p) y numero de entradas(m)
  
  %Elimina el cero q aparece en el numerador
    for i=1:p
        for j=1:m
            if Bn{i,j}(1)==0 %&& length(Bn{i,j})~=1
                Bn{i,j}=Bn{i,j}(2:end);
            end
        end
    end
% _______________________________________________________________
  %Llena la celda diagonal de A (Con el minimo común multiplo)
  for i=1:p
    aux=An{i,1};
    for j=2:m
        aux=conv(aux,An{i,j});
    end
    A{i,i}=aux;
    %Verifica si existen polos con multiplicidad en la misma fila (salida) 
    %para quitarlos del mínimo común múltiplo, caso MIMO
    if p~=1
        Au1=round(roots(aux),4);
        Pol=unique(Au1);
        A{i,i}=poly(Pol);
    end
  end
 
  
%________________________________________________________________  
  %Llena la celda de B utilizando el minimo comun multiplo (A)
  for i=1:p
    for j=1:m
        aux=Bn{i,j};
%         for k=1:m
            rA=round(roots(A{i,i}),4); %nuevo
            rAn=round(roots(An{i,j}),4);%nuevo
            kk = 1;
            while(kk<=length(rA))
                for jj = 1:length(rAn)
                    if(rA(kk) == rAn(jj))
                        rA = rA(find(rA ~= rA(kk)));
                    end
                end
                kk = kk+1;
            end
            %pA=poly(rA(find(rAn~=rA)));%nuevo
            pA=poly(rA);%nuevo
            aux=conv(aux,pA);
%             if k~=j
%                 aux=conv(aux,An{i,k});
%             end
%         end
        B{i,j}=aux;
    end
  end
  
   %Calcula el tamaño del Polinomio A y B
 for i=1:p
    na(i)=length(A{i,i})-1;
    for j=1:m
        nb(i,j)=length(B{i,j})-1;
    end
 end
end