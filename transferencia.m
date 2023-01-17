function [yk] = transferencia(FT,u,y,k)
% [y] = transferencia(FT,u,y,k)
% Respuesta causal de una funcion de transferencia
% FT: funcion de transferencia
% u: Entrada
% y: salida
% k: Instante de tiempo (Se debe llevar en consideracion que si el sistema
% presenta retardo debe adicionarse el retardo al loop de control es decir en el FOR)
% yk: Salida actual
[B,A]=tfdata(FT,'v');  %Numerador e denominador do processo
d=FT.iodelay;
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

yk=yb-ya;
end