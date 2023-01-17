function M = sylvestre(B,A,d)
    nb=length(B)-1;                 %Ordem do numerador
    na=length(A)-1;                 %Ordem do Denominador
    nr=nb+d;                        %Ordem do polinomio R (+ 1 para incluir el coeficiente independiente)
    ns=na+1;                        %Ordem do Polinomio S (+ 1 para incluir el coeficiente independiente)
    
    %Delata A. Multiplica por integrador
    DA=conv(A,[1 -1]);
    nda=length(DA);
    
    LM=nr+ns; %Cumprimento da matriz
    M=zeros(LM,LM);
    M(1:nda,1)=DA';
    M(1+d:length(B)+d,nr+1)=B';
    
    %Polinomio R
    for k=2:nr
        M(k:end,k)=M(1:end-k+1,1);         % Forma o polinomio R             
    end
    
    %Polinomio S
    for k=1:ns-1
        M(k+1:end,nr+1+k)=M(1:end-k,nr+1);         % Forma o polinomio S                
    end
end