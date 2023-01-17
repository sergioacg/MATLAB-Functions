% Example extracted from the book:
% Control of Dead-time Processes, Springer-Verlag, 2007
% by Julio Normey-Rico & Eduardo F. Camacho

% ------------------------------------------------------------- %
%                                                               %
% For the elimination of zeros on the right of a polynomial     %
%                                                               %
%                                                               %
%                                                               %
%                                                               %
% ------------------------------------------------------------- %



function[pz]=subzder(p)

np = length(p);

[nz]=zerosder(p);


pz = p(1:np-nz);
