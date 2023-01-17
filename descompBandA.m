function [B,A,d] = descompBandA(FT)
    %[B,A,d] = descomp(FT)
    %descompone uma função de transferencia em numerador (B) denominador
    %(A) e atraso (d) em tempo discreto
    [Bn,An]=tfdata(FT,'v');  %Numerador e denominador do processo
    dn=FT.iodelay;
    [ny,nu]=size(An); %Determino el numero de denominadores que tengo
    for i=1:ny
        for j=1:nu
            B=Bn{ny,nu}
        end
    end
end