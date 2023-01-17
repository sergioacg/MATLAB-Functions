function [L,R,S] = CondMin(K)
% Uma maneira de determinar quais as vari�veis devem ser re-escalonadas � 
% atrav�s do c�lculo do condicionamento m�nimo, isto �, determinar as matrizes
% que pr�- e p�s-multiplicadas pela matriz K resultam em um Ro m�nimo (Ro*), 
% isto �:
%  Ro*(K) = Min Ro(L*K*R)
%           L,R
%  Ro: Condicionamento da matriz
%  Ro*: Condicionamento m�nimo da matriz
%  
% Considerando L e R matrizes diagonais, tem-se como resultado do problema 
% de otimiza��o acima quais as sa�das e entradas que devem ser 
% re-escalonadas, respectivamente, pois:
% 
%    ye = L * y        e      xe = R^-1 * x
%
%    Onde: ye(Sa�da escalonada), y(sa�da do processo), xe(entrada escalonada)
%           x(entrada do Processo)
%
%    Como Chamar a Fun��o:
%
%    [L,R,S] = CondMin(K)
%    K = Matriz de Ganhos Estaticos.
%    S = Matriz com condicionamento m�nimo--- S=cond(L*K*R)
%
% By: Sergio Casta�o
% Rio de Janeiro
% 2017
% http://controlautomaticoeducacion.com/
[m,n]=size(K);
li=zeros(1,m+n);   %Limite inferior variables
ls=ones(1,m+n);   %Limite superior variables
% li=[];   %Limite inferior variables
% ls=[];   %Limite superior variables
A=[];            %Matriz de Desigualdad
B=[];            %Igualdad desigualdades
Ae=[];           %Matriz equivalencias
Be=[];           %Igualdad Equivalencias
X0(1:m+n)=0.1;
% opContr = optimset('Algorithm','sqp','UseParallel',0,...
%                    'display','off','TolX',1e-6,'TolFun',1e-7,...
%                    'TolCon',1e-5,'MaxFunEvals',8000); 

J=@(X)funobj(X,K); %Fun��o Objetivo


%Minimiza a Funcao Objetivo
% [Xt,~,fminflag]=fmincon(J,X0,A,B,Ae,Be,li,ls,[],opContr);
[Xt,~,fminflag]=fmincon(J,X0,A,B,Ae,Be,li,ls,[]);

if exist('fminflag','var')
%     disp('fminflag')
    if fminflag == -2
        fprintf('No feasible point found \n')
    elseif fminflag == 0
        fprintf('Too many function evaluations or iterations \n')
    elseif fminflag == 1
        fprintf('Convergiu \n')
    else
        fprintf('Convergiu \n')
    end
  L=blkdiag(diag(Xt(1:m))*eye(m));
  R=blkdiag(diag(Xt(m+1:end))*eye(n));
  S=cond(L*K*R);
end

function [fobj] = funobj(X,K)
    
    [m,n]=size(K);
    L1=blkdiag(diag(X(1:m))*eye(m));
    R1=blkdiag(diag(X(m+1:end))*eye(n));
    fobj=cond(L1*K*R1);
