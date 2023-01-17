function [Hs] = sym2tfd(FTSym, Ts)
%Função para transformar uma função de transferencia discreta ou continua symbolica
%em uma função de tranferencia numerica discreta ou continua
%
% [Hs] = sym2tfd(FTSym, Ts)
%   FTSym:  Função de Transferencia simbolica discreta ou continua (Z ou S)
%   Ts:     Periodo de amostragem (Ts=0 para FT Continua)
%
%Exemplo
%   >>syms z
%   >>g=tf[1,[2 1],1)
%   >>H= tf2sym(g,z)
%   >>Hd=sym2tfd(g, z)
%% By Sergio Andres Castaño Giraldo
%% Universidade Federal de Santa Catarina (UFSC - Brasil - Florianópolis) - 2015
%% Universidade Federal de Rio de Janeiro (UFRJ - Brasil - Rio de Janeiro) - 2017
%% http://controlautomaticoeducacion.com/

M=size(FTSym);  %Determina o cumprimento de FT
[nz,dz] = numden(FTSym);

 
 for w=1:M(1,1)
     for ww=1:M(1,2)
         %% Pergunto se é continuo
            if Ts==0
                n=coeffs(nz(w,ww)); %extraigo coeficientes
                n=flip(n);  %Cambio de posicion en el vector
                m=length(n)-1; %determino el orden del polinomio
                s=symvar(FTSym); %Busca o simbolplo da FT
                if m>0
                    aux=0;
                    for q=0:m
                       aux=aux+n(m+1-q)*s^q; %Construyo polinomio auxiliar
                    end
                    pl=nz(w,ww)/aux; %De nz extraigo el atraso
                    nz(w,ww)=aux;
                else
                    pl=nz(w,ww)/n; %De nz extraigo el atraso
                    nz(w,ww)=pl;
                end
                pl=simplify(pl,'Steps',100);
                L=abs(double(coeffs(diff(pl,s)))); %obtengo el atraso
                
            end
        %% _________________________________________________________________
         num=sym2poly(nz(w,ww));
         den=sym2poly(dz(w,ww));
          num=num/den(1);
          den=den/den(1);
          Hs(w,ww)=tf(num,den,Ts);
          if Ts==0
              Hs(w,ww).iodelay=L; %Atraso continuo
          end
     end
 end
end