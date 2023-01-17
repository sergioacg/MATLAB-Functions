function [B,A,d] = descomp(FT)
% By:  Sergio Andres Castaño Giraldo
% http://controlautomaticoeducacion.com/
% ______________________________________________________________________
%[B,A,d] = descomp(FT)
%descompone uma função de transferencia em numerador (B) denominador
%(A) e atraso (d) em tempo discreto. (Retorna CELDAS). Se o numerador
%apresenta mesmo ordem que o denominador no caso discreto, se retira um
%atraso e se incorpora no numerador para manter a logica da janela
%deslizante do controlador preditivo,garantir sempre u(k-1).
    [B,A]=tfdata(FT,'v');  %Numerador e denominador do processo
    d=FT.iodelay;
    
end