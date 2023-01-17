function [IR,dI,dImax]=robutness(MR,MN,Con,Fr,w1,w2,n,grafica,esc)
%///////////////////////////////////////////////////////////////////////
%//////       Por: Sergio Andres Castaño Giraldo          /////////////
%//////       UFSC - Florianópolis -  Brasil (2015)       /////////////
%///////////////////////////////////////////////////////////////////////
% SISTEMA SISO
% Grafica el indice de robustez multiplicativo de PSF ( parecido al Inverso de la funcion de
% transferencia en el dominio frecuencial) para un proceso nominal y un
% proceso real (dscreto o continuo) con el controlador diseñado para el
% proceso nominal, y tambien grafica los errores de modelage por medio del
% indice de robustez multiplicativo WI=abs(P-Pn)/abs(Pn)y tambien por medio
% del indice maximo de robustez multiplicativo max(WI(w))
%
%[IR,dI,dImax]=robutness(MR,MN,Con,Fr,w1,w2,n,grafica,esc)
%----------------- Salidas -------------------
% IR:   Indice de Robustez
% dI:   Incerteza Multiplicativa
% dImax:Incerteza MAXIMA
%----------------- Entradas -------------------
% MR:   Modelo real
% MN:   Modelo nominal
% Con:  Controlador 
% Fr:   Filtro del predictor
% w1:   Frecuencia inferior (log10(w1))
% w2:   Frecuencia superior (log10(w2)) Si es discreto = log10(pi/Ts)
% n:   numero de puntos en el grafico
% grafica:  numero binario, se coloca en 1 si se quiere graficar o en 0 si
%           no se quiere graficar
% esc:  Tipo de Escala Logaritmica
%        0 si se quiere la "X" log y la "Y" lineal
%        1 si se quiere la "X" log y la "Y" log
%________________________________________________________________________

w=logspace(w1,w2,n); %Frecuencia
G=MN;
G.iodelay=0;

%Respuesta en Frecuencia de las FT
Pw = freqresp(MR,w);  
Pnw = freqresp(MN,w);
Gnw = freqresp(G,w);
Cw = freqresp(Con,w);  
Frw = freqresp(Fr,w);   

Cw = reshape(freqresp(Con,w),n,1);    
Gnw = reshape(freqresp(G,w),n,1); 
Pnw = reshape(freqresp(MN,w),n,1); 
Pw = reshape(freqresp(MR,w),n,1); 
Frw = reshape(freqresp(Fr,w),n,1);  

dI(1:n)=0;
IR(1:n)=0;
dImax(1:n)=0;

%% Etapa que funciona lo comentaré para colocar producto punto
for i=1:n
    %Incerteza Multiplicativa
    dI(i)=abs((Pw(i)-Pnw(i))/(Pnw(i))); 
    %Indice de Robustez Multiplicativa
    IR(i)=abs((1+Cw(i)*Gnw(i))/(Cw(i)*Gnw(i)*Frw(i)));
    
%     %Incerteza Aditiva
%     dI(i)=abs(Pw(i)-Pnw(i)); 
%     %Indice de Robustez Aditiva
%     IR(i)=abs((1+Cw(i)*Gnw(i))/(Cw(i)*Frw(i)));
    
    %Incerteza Maxima
    dImax(i)=max(dI(1:i)); 
end
%% Etapa nueva con producto punto
%% Indice de Robustez Aditiva
%     IR=abs((1+Cw.*Pnw)./(Cw.*Frw));
%     dI = abs( (Pw - Pnw) );
%% Indice de Robustez Multiplicativa
%     dI = abs( (Pw - Pnw) ./ Pnw );
%     IR=abs((1+Cw.*Gnw)./(Cw.*Gnw.*Frw));
% 
%     dImax=max(dI(1:end)');

%% Graficas
if grafica~=0 && grafica~=1
    grafica=1;
    display('el parametro grafica de entrada debe ser 0 o 1');
    display('Se colocó en 1 por defecto para graficar');
end

if esc~=0 && esc~=1
    esc=0;
    display('el parametro esc debe ser 0 o 1');
    display('Se colocó en 0 por defecto para graficar');
end
%% Si se desea graficar
    if grafica
        % parameters for figures
        %tamletra=12;
        tamletra=28;
        if esc==0
            semilogx(w,20*log10(IR),w,20*log10(dI),w,20*log10(dImax),'LineWidth',2),grid
            %semilogx(w,20*log10(IR),w,20*log10(dI),'LineWidth',2),grid
        end
        if esc==1
            loglog(w,IR,w,dI,w,dImax,'LineWidth',2),grid
            %loglog(w,IR,w,dI,'LineWidth',2),grid
        end
        legend('$$dP(\omega)$$','$$|\delta P(\omega)|$$','$$|\overline{\delta P(\omega)}|$$','Location','NorthWest','interpreter','latex')
        ylabel('Magnitude', 'FontSize', tamletra,'interpreter','latex');
        xlabel('Frequency', 'FontSize', tamletra,'interpreter','latex');
        set(gca,'FontSize',tamletra,'TickLabelInterpreter','latex')
    end
end