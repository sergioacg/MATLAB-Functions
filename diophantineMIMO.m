%---------------------------------------------------------- %
%                                                           %
% Solution of the MIMO Diophantine equation                 %
% Ver: 2.0                                                          %
%---------------------------------------------------------- %
%[E,En,F] = diophantine(A,N,dmin)
% A = Denominator MIMO (Cell Matrix)
% N = Ventana de Predicción
% E = Polinomio completo E diofantina
% En = Todos los polinomios E
% F = Polinomios F Diofantina
% dmin = Vector con los retardos minimos del sistema MIMO

function[E,En,F] = diophantineMIMO(A,N,dmin)
   [p,m]=size(A); %Numero de salidas(p) y numero de entradas(m)
   for i=1:p
       [En1,Fn] = diophantine(A{i,i},N(i),dmin(i)); %Calculo de la funcion Diofantina
       E{i}=En1(end,:); %Polinomio E seria la ultima fila arrojada por la funcion
       F{i}=Fn;
       En{i}=En1;
   end
end