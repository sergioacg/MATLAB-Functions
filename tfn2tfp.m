% Example extracted from the book:
% Control of Dead-time Processes, Springer-Verlag, 2007
% by Julio Normey-Rico & Eduardo F. Camacho

% ------------------------------------------------------------- %
%                                                               %
% Transfroms a transfer function in z^(-1) to transfer functions %
% in z eliminating the zeros that do not affect the result      %
%                                                               %
%                                                     %
% ------------------------------------------------------------- %

function[nump,denp]=tfn2tfp(num,den)

[num]=subzder(num);
[den]=subzder(den);

nn = length(num);
nd = length(den);

if nd >= nn
    nump = [num,zeros(1,nd-nn)];
    denp = den;
else
    nump = num;
    denp = [den,zeros(1,nn-nd)];
end


[nump] = subziz(nump);
[denp] = subziz(denp); 

