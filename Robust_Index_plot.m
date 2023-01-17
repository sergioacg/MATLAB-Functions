function Robust_Index_plot(w,n,dP,C,G,Fr)
%Grafica el indice de Robustez del PSF
% Robust_Index_plot(w,n,dP,C,G,Fr)
% w: Frecuencia
% n: Numero de puntos
% dP: Errordel sistema (multiplicativo, (P-Pn)/Pn en frecuencia)
% C: Controlador
% G: Modelo sin retardo
% Fr: Filtro de Robustez
% Diciembre del 2020


Cw = reshape(freqresp(C,w),n,1);    
Gnw = reshape(freqresp(G,w),n,1); 
Frw1 = reshape(freqresp(Fr,w),n,1);  

%Indice de Robustez Aditiva
% IR=abs((1+Cw.*Pnw)./(Cw.*Frw1));
%Indice de Robustez Multiplicativa
IR=abs((1+Cw.*Gnw)./(Cw.*Gnw.*Frw1));

FS = 15;
figure
semilogx(w,20*log10(IR),w,20*log10(dP),'LineWidth',3),grid
legend('iR(\omega)','|\delta P(\omega)|','Location','best')
ylabel('Magnitude (dB)', 'FontSize', FS);
xlabel('Frequency', 'FontSize', FS);