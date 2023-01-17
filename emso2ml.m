%EMSO2ML imports data from a EMSO's result file as a MATLAB structure.
%   FLOWSHEET=EMSO2ML(FILE) returns the structure FLOWSHEET containing
%   all elements of a previously saved EMSO's result FILE.
%   FILE should be a string with the path for the saved result.
%
%   Example:
%   If you have a 'FlowSheet' which contains a 'DEVICES' called 'CSTR'
%   and you have saved the simulation results in file 'results.rlt'
%   you can import the data with the following command:
%
%   >> flowsheet = emso2ml('results.rlt');
%
%   Then you can plot the CSTR temperature (T) vs. the conversion (X)
%   using the PLOT function:
%
%   >> plot(flowsheet.CSTR.T, flowsheet.CSTR.X);

% author: Rafael de Pelegrini Soares - rafael@rps.eng.br

function [dev] = emso2ml(file, fid, dev)

if nargin < 2
   fid = -1;
end
if nargin < 3
   dev = [];
end

if fid < 0
   fid = fopen(file, 'rt');
   if fid < 0 , error('Erro na abertura do arquivo.');end
   
   dev.name = str2mat(fscanf(fid, '%s /n'));	% process name
   n=fscanf(fid,'%d',1);		% time length
   dev.time = fscanf(fid, '%g', [n,1]);
end

name = str2mat(fscanf(fid, '%s /n')); %device name
if isempty(dev)
   dev.name = name;
end
ndim = fscanf(fid,'%d',1);	% number of dimension
if ndim > 0
	dim = fscanf(fid,'%d',[1,ndim]);
   nd = prod(dim);
   values = [];
   for j=1:nd
      ntime = fscanf(fid,'%d',1);		% time length
      values = [values, fscanf(fid,'%g',[ntime,1])];
   end
   dim = [ntime, dim(end:-1:1)];
   dev.val = squeeze(reshape(values, dim));
end

ndev = fscanf(fid,'%d',1);	%number of base-devices
for i=1:ndev
   dev = emso2ml(file, fid, dev);
   %eval( [ 'dev.' sub.name ' = sub;' ] );
end

ndev = fscanf(fid,'%d',1);	%number of sub-devices
for i=1:ndev
   sub = emso2ml(file, fid);
   eval( [ 'dev.' sub.name ' = sub;' ] );
end

if nargin < 2 & fid > 0
   fclose(fid);
end

