function [yp] = OptimalPredictor2(Fr,Pz,Gz,u,y,k)
%  the optimal predictor (OP)
%
%    [yp] = OptimalPredictor(Fr,So,u,y,k)
%
%  yp = Output predictor
%  Fr = Filtered Smith Predictor
%  So = Stable Filter
%  u = Control Action
%  y = Output Process
%  k = Actual discrete time
% Optimal predictors were used in the context of model predictive control (MPC). While SPs are
% used to compensate pure dead time, OPs are usually employed to predict
% the future behaviour of the plant in a multistep ahead receding horizon. OPs
% do not explicitly appear in the resulting MPC structure, although it has been
% shown that the MPC structure is equivalent to an OP plus a primary control-
% ler
% By: Sergio Andres Castaño Giraldo
% Rio de Janeiro 2018
% https://controlautomaticoeducacion.com
% https://www.youtube.com/SergioCastañoControlAutomaticoEducacion
%

      Ts=Fr.Ts;
      t = 0:Ts:(k-1)*Ts;
      
      %Saida do Modelo
      ypz=lsim(Pz,u(:,1:k),t,'zoh')';
      
      %Saida do Modelo Rapio
      ygz=lsim(Gz,u(:,1:k),t,'zoh')';
      
      %Erro de modelo
      eM=y(:,1:k)-ypz;
      
      %Salida del Filtro Fr
      yfr=lsim(Fr,eM,t,'zoh')';
      
      
      %Salida Predita
      yp=ygz+yfr;
end