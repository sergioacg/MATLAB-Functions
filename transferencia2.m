function [yk] = transferencia2(B,A,d,u,y,k)
% By:  Sergio Andres Castaño Giraldo
% http://controlautomaticoeducacion.com/
% ______________________________________________________________________
% [yk] = transferencia2(B,A,d,u,y,k)
% Respuesta causal de una funcion de transferencia
% B: vector numerador discreto
% A: Vector denominador discreto
% d: Retardo discreto
% u: Entrada
% y: salida
% k: Instante de tiempo (Se debe llevar en consideracion que si el sistema
% presenta retardo debe adicionarse el retardo al loop de control es decir 
% en la variable del incremento del FOR)
% yk: Salida actual

yb=0;
if B(1)==0
    for i=2:length(B)
       yb=yb+B(i)*u(k+1-i-d);
    end
else
    for i=1:length(B)
       yb=yb+B(i)*u(k+1-i-d);
    end
end

ya=0;
for i=2:length(A)
    ya=ya+A(i)*y(k-i+1);
end
if length(A)==1
    yk=yb;
else
yk=(yb-ya)/A(1);
end
end