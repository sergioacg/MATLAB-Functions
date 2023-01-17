% Example extracted from the book:
% Control of Dead-time Processes, Springer-Verlag, 2007
% by Julio Normey-Rico & Eduardo F. Camacho

% ------------------------------------------------------------- %
%                                                               %
% For the elimination of zeros on the left of a polynomial     %%                                                               %
%                                                     %
%                                                               %
%                                                               %
%                                                               %
%                                                               %
% ------------------------------------------------------------- %



function[pz]=subziz(p)

np = length(p);

[nz]=zerosiz(p);


pz = p(nz+1:np);
