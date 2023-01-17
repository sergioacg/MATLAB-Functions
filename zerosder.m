% Example extracted from the book:
% Control of Dead-time Processes, Springer-Verlag, 2007
% by Julio Normey-Rico & Eduardo F. Camacho

% ------------------------------------------------------------- %
%                                                               %
% Computes the number of zeros on the right of a polynomial                                                              %
%                                                               %
%                                                               %
%                                                               %
% ------------------------------------------------------------- %


function[z]=zerosder(p)

np = size(p);
np = np(2);

presicion = 1e-12;

cuenta = 1;
z = 0;
for i = 1:np
    if abs(p(np+1-i)) >= presicion
        cuenta = 0;
    end
    z = z+cuenta;
end

