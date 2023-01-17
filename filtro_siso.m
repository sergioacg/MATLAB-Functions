function [Fr] = filtro_siso(Pd,alfa,raio,kn)
%
% [Fr] = filtro_siso(Pd,alfa,raio,kn)
%
% Funcao para calculo do filtro de robustez Fr(z)
%
% Pd:   define o processo discreto monovariÃ¡vel com atraso
% alfa: define o valor dos polos desejados
% raio: define o valor maximo do modulo dos polos desejados
% nk:   Multiplicidade del numerador (Como minimo debe ser igual a los
% polos que se desea eliminar


% Estabelece a representaï¿½ï¿½o do processo

G=Pd;                                % Define G como o modelo rï¿½pido
set(G,'inputdelay',0)
set(G,'outputdelay',0)
set(G,'iodelay',0)
d=Pd.iodelay; 

h=Pd.Ts;
lista_p=[1];

polos=pole(G);                  % Obtem os polos de G(z)
p_ind=polos(find(abs(polos)>=raio))';  % Obtem os polos indesejados de G(z)
nm=length(p_ind);
nk=nm;

% nk=kn;

% if nm > nk 
%     nk=nm;
%     display('Se aumento la multiplicidad de nk para poder eliminar los polos que deseabas');
% end
% if d==0 
%     nk=nk+1;
% end
pd=0; %Incrementa tamanho de A caso não exista Atraso
if d==0 
    pd=2; %A deve se incrementar +2 para completar a ordem da direita
          % que é feita sempre que nao tem atraso, a ser um ordem menor
          %que o termo que esta a esquerda.
    nk=nk+pd;
end
lista_p=[lista_p p_ind];        % lista de polos indesejados

px=poly(lista_p);
%ordem=length(lista_p); 

%Denominador do filtro
Dr=1;
for i=1:nk
    Dr=conv(Dr,[1 -alfa]);
end
ordem=(length(Dr)-1)+d; %Maximo orden do termo da esquerda (Dr z^d)

pn=1; %posicion del polo en px
lpx=length(px); %Longitud de los polos px

%Vou ter uma incognita a mais do ordem
A=zeros(ordem+1,ordem+1+pd); %Crea la matriz com os coeficientes das incognitas
ip=1; %Utilizada para aumentar de a uma fila por coluna na matriz A (Sylvestre)
for j=ordem+2-d:ordem+1+pd  %Começo na coluna d+1
    
    for i=ip:ordem+1 %Começo colocando os valores dos polos que quero eliminar
        if pn<=lpx   %de forma de uma matriz de silvestre
            A(i,j)=px(pn);
            pn=pn+1;
        end
    end
    pn=1; %Reinicia o indice que quenta na matriz dos polos que quero elimnar
    ip=ip+1; %Aumento de uma coluna cada que coloco o total de polos
    
end

%Encho as primeiras colunas da matriz, que contem os coeficientes do
%numerador(Nr) do filtro (Dr z^d + Nr)
j=1;
for i=d+1:ordem+1
       A(i,j)=1; 
       j=j+1;
end

%Encho Matriz B Com os polos desejados do filtro
B=zeros(ordem+1,1);
B(1)=1;
B(2:length(Dr),1)=Dr(1,2:length(Dr));
% if d==0
%     B=px'-B;
%     A=-A;
% end

X=A\B; %Solucion del sistema de ecuaciones

%Numerador do filtro
Nr=[];
for i=1:ordem+1-d
    Nr=[Nr X(i)];
end

sum(Nr)/sum(Dr);
if isempty(p_ind)
    Fr=tf(1,1,h);
else
    Fr=tf(Nr,Dr,h);
end

end