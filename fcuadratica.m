function [y,vt,M,r] = fcuadratica(a,b,c)
% Esta función calcula y grafica los puntos de una función cuadratica
% expresada de la forma y= ax^2 + bx + c, la sintaxis es:
%
%  [y] = fcuadratica(a,b,c)
%
% Donde:
% y   =  Puntos de la función Cuadratica
% a   = Coeficiente que acompaña a x^2
% b   = Coeficiente que acompaña a x
% c   = Coeficiente independiente

%Calcular Vertice
vt=-b/(2*a);

%Creo los puntos
x=vt-5:0.5:vt+5;

%Ecuación Cuadrática
y=a*x.^2+b*x+c;

%Graficar
plot(x,y),grid
hold on
plot(vt,a*vt.^2+b*vt+c,'.k','MarkerSize',25)

%Maximo o minimo
if a<0
    disp('Máximo')
    M=max(y);
elseif a>0
    disp('Mínimo')
    M=min(y);
else
    disp('Linea Recta')
    M=0;
end

%Raízes
% r(1)=(-b+sqrt(b^2-4*a*c))/(2*a);
% r(2)=(-b-sqrt(b^2-4*a*c))/(2*a);
r=roots([a b c]);




