function [IR,dI,dImax]=robutness(MR,MN,Con,Fr,w1,w2,n,grafica,esc)
% Function to calculate and plot the Multiplicative Robustness Index (MRI) for a nominal process and a real process (discrete or continuous), 
% with the controller designed for the nominal process. It also plots the modelling errors using the Multiplicative Robustness Index, 
% and the maximum of this index.
% Created by Sergio Andres Castaño Giraldo
% UFSC - Florianópolis - Brasil, 2015
% https://controlautomaticoeducacion.com/
% 
%----------------- Outputs -------------------
% IR:   Multiplicative Robustness Index
% dI:   Multiplicative Uncertainty
% dImax: Maximum Uncertainty
%----------------- Inputs -------------------
% MR:   Real Model
% MN:   Nominal Model
% Con:  Controller 
% Fr:   Filter for the predictor
% w1:   Lower frequency (log10(w1))
% w2:   Upper frequency (log10(w2)) If it is discrete = log10(pi/Ts)
% n:   Number of points in the plot
% grafica:  Binary number, it is set to 1 if you want to plot or 0 if you do not want to plot
% esc:  Type of Logarithmic Scale
%        0 if you want "X" log and "Y" linear
%        1 if you want "X" log and "Y" log
%________________________________________________________________________

w=logspace(w1,w2,n); %Frequency
G=MN;
G.iodelay=0;

%Frequency Response of the Transfer Functions
Cw = reshape(freqresp(Con,w),n,1);    
Gnw = reshape(freqresp(G,w),n,1); 
Pnw = reshape(freqresp(MN,w),n,1); 
Pw = reshape(freqresp(MR,w),n,1); 
Frw = reshape(freqresp(Fr,w),n,1);  

% Initialize the variables to store the results
dI(1:n)=0;
IR(1:n)=0;
dImax(1:n)=0;

%% Loop over the frequency points
for i=1:n
    % Calculate the Multiplicative Uncertainty
    dI(i)=abs((Pw(i)-Pnw(i))/(Pnw(i))); 
    % Calculate the Multiplicative Robustness Index
    IR(i)=abs((1+Cw(i)*Gnw(i))/(Cw(i)*Gnw(i)*Frw(i)));
    
    % Calculate the Maximum Uncertainty so far
    dImax(i)=max(dI(1:i)); 
end

%% Check the plot settings
if grafica~=0 && grafica~=1
    grafica=1;
    display('The input parameter "grafica" must be 0 or 1');
    display('It was set to 1 by default for plotting');
end

if esc~=0 && esc~=1
    esc=0;
    display('The input parameter "esc" must be 0 or 1');
    display('It was set to 0 by default for plotting');
end

%% Plotting, if desired
    if grafica
        % Parameters for figures
        tamletra=28;
        if esc==0
            semilogx(w,20*log10(IR),w,20*log10(dI),w,20*log10(dImax),'LineWidth',2),grid
        end
        if esc==1
            semilogx(w,IR,w,dI,w,dImax,'LineWidth',2),grid
        end
        % Define the legend, labels and font size
        legend('$$dP(\omega)$$','$$|\delta P(\omega)|$$','$$|\overline{\delta P(\omega)}|$$','Location','NorthWest','interpreter','latex')
        ylabel('Magnitude', 'FontSize', tamletra,'interpreter','latex');
        xlabel('Frequency', 'FontSize', tamletra,'interpreter','latex');
        set(gca,'FontSize',tamletra,'TickLabelInterpreter','latex')
    end
end
