function A = cell2mat2(B)
[m,n]=size(B);
c1=zeros(m,n);
f1=c1;
col=0; fil=0;
n1=0; m1=0;
%Encontrar dimension de los elementos del Cell
for i=1:m
    for j=1:n
        aux=size(B{i,j});
        col = col+aux(2);
        if aux(1)>fil
           fil=aux(1);
        end
        f1(i,j)=aux(1);
        c1(i,j)=aux(2);
    end
    if col>n1
        n1=col;
    end
    m1=m1+fil;
    col=0; fil=0;
end
A=zeros(m1,n1);
c1m=[0 max(c1)];
f1T=f1';
f1m=[0 max(f1T)];

for i=1:m
    for j=1:n
        A(1+sum(f1m(1:i)):f1(i,j)+sum(f1m(1:i)) , 1+sum(c1m(1:j)):c1(i,j)+sum(c1m(1:j)))=(B{i,j});
     
    end
end