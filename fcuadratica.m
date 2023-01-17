function [y,vt,M,r] = fcuadratica(a,b,c)
% Esta funci�n calcula y grafica los puntos de una funci�n cuadratica
% expresada de la forma y= ax^2 + bx + c, la sintaxis es:
%
%  [y] = fcuadratica(a,b,c)
%
% Donde:
% y   =  Puntos de la funci�n Cuadratica
% a   = Coeficiente que acompa�a a x^2
% b   = Coeficiente que acompa�a a x
% c   = Coeficiente independiente

%Calcular Vertice
vt=-b/(2*a);

%Creo los puntos
x=vt-5:0.5:vt+5;

%Ecuaci�n Cuadr�tica
y=a*x.^2+b*x+c;

%Graficar
plot(x,y),grid
hold on
plot(vt,a*vt.^2+b*vt+c,'.k','MarkerSize',25)

%Maximo o minimo
if a<0
    disp('M�ximo')
    M=max(y);
elseif a>0
    disp('M�nimo')
    M=min(y);
else
    disp('Linea Recta')
    M=0;
end

%Ra�zes
% r(1)=(-b+sqrt(b^2-4*a*c))/(2*a);
% r(2)=(-b-sqrt(b^2-4*a*c))/(2*a);
r=roots([a b c]);




