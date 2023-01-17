% Example extracted from the book:
% Control of Dead-time Processes, Springer-Verlag, 2007
% by Julio Normey-Rico & Eduardo F. Camacho

% ------------------------------------------------------------- %
%                                                               %
% Transfroms a transfer function in z^(-1) to transfer functions %
% in z     %
%                                                               %
%                                                     %
% ------------------------------------------------------------- %

function[nump,denp]=tfzn2tfzp(num,den)


nn = length(num);
nd = length(den);

if nd >= nn
    nump = [num,zeros(1,nd-nn)];
    denp = den;
else
    nump = num;
    denp = [den,zeros(1,nn-nd)];
end


