function [Index]=comprom_robustez(MR,dImax,Con,Fr,w1,w2,n,gamma)
%///////////////////////////////////////////////////////////////////////
%//////       Por: Sergio Andres Castaño Giraldo          /////////////
%//////       UFSC - Florianópolis -  Brasil (2015)       /////////////
%///////////////////////////////////////////////////////////////////////
%
%Con el motivo de alcanzar una solucion de compromiso entre la robustez de
%la estrategia de predictor smith filtrado (PSF) y la rapidez de la
%respuesta de rechazo de perturbaciones se analisa si
%| C(w)P(w) |
%|----------|*|dIncer_Max(w)|*|Fr(w)|<= gamma < 1
%|1+C(w)P(w)|
%
%[Index]=comprom_robustez(MR,dImax,Con,Fr,w1,w2,n,gamma)
%----------------- Salidas -------------------
% Index:  Indica si cumple con el compromiso '1' o si no cumple '0'
%----------------- Entradas -------------------
% MR:   Planta real
% dImax:Incerteza MAXIMA
% Con:  Controlador continuo
% Fr:   Filtro
% w1:   Frecuencia inferior (log10(w1))
% w2:   Frecuencia superior (log10(w2))
% n:   numero de puntos en el grafico
%________________________________________________________________________

%Respuesta en Frecuencia de las FT
w=logspace(w1,w2,n); %Frecuencia
Pw = freqresp(MR,w);   
Cw = freqresp(Con,w);  
Frw = freqresp(Fr,w);  
Index=1; %Inicialmente coloco que respeta
i=1;
while i<=n && Index==1
    %Compromiso entre robustez e rapidez
    In(i)=abs((Cw(i)*Pw(i))/(1+Cw(i)*Pw(i)))*abs(dImax(i))*abs(Frw(i)); 
    if In(i)<=gamma
        Index=1;
    else
        Index=0;
    end
    i=i+1;
end
end