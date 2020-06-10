function [hdata, xm, fm] = process_scandata(g_data,Nvar,vrange,flag_plot,isel)
%process the data saved in optimization
%Input:
%   g_data, contains all the data, each row is a solution, the first Nvar
%       elements are the parameter values, the Nvar+1 element is the objective
%       function value for the solution. It may have more elements that
%       describe the solution.
%   Nvar, the number of variables, can be empty.
%   vrange, the ranges for the parameters, needed for converting normalized
%       parameters. By default use the global variable.
%   flag_plot, indicator for plotting or not. Plot 1 shows the history of
%       all solutions. Plot 2 shows the distance of all solution to the
%       preferred solution.
%   isel, select the isel (isel = 1, 2, 3, etc) best solution as the preferred
%       solution. This allows us to remove outliers. default to 1.
%
%Output:
%   hdata, a structure that contains the original data and sorted data
%   fields of hdata:
%       g_data, original data matrix, with all solutions in the order of
%           the time of evaluation.
%       x_data, same as g_data, but the parameters in x_data are normalized,
%           the last column is the distance to the preferred solution .
%       h_data, contains the best solution in the history.
%       hx_data, same as h_data, but the parameters in x_data are normalized.
%       xm, normalized parameter of the best solution
%       fm, the objective of the best solution
%example:
%>> [data_1,xm,fm] = process_scandata(g_data);
%>> [data_1,xm,fm] = process_scandata(g_data,Nvar,vrange,'plot');
%
%created by X. Huang, 3/2013
%

if nargin<2 || isempty(Nvar)
    Nvar = size(g_data,2)-1;
end
if nargin<3 || isempty(vrange)
    global vrange
end
if nargin<4 || isempty(flag_plot)
    flag_plot = 'plot';
end
if nargin<5 || isempty(isel)
    isel = 1;  %choose #1, no outliers
end

Ncnt = size(g_data,1);

hdata.Ncnt = Ncnt;
hdata.g_data = g_data;

%the best solution
% [mp,imp] = min(g_data(:,Nvar+1));

%sometimes we want to throw away solutions with the lowerst objective
%values since they may be outliers
[tmpobj, indxobj] = sort(g_data(:,Nvar+1));

fm = tmpobj(isel);
imp = indxobj(isel);

xm = (g_data(imp,1:Nvar)'-vrange(:,1))./(vrange(:,2)-vrange(:,1));
for ii=1:Ncnt
    x1 = (g_data(ii,1:Nvar)'-vrange(:,1))./(vrange(:,2)-vrange(:,1));
    dist = norm(x1 - xm);
    x_data(ii,:) = [x1(:)',g_data(ii,Nvar+1), dist];
end

hdata.xm = xm;
hdata.fm = fm;
hdata.x_data = x_data;

%% find the best solution through the history
h_data = zeros(size(g_data))*NaN;
xh_data = zeros(size(x_data));
h_data(1,:) = g_data(1,:);
xh_data(1,:) = x_data(1,:);
for ii=2:Ncnt
    h_data(ii,:) = h_data(ii-1,:);
    xh_data(ii,:) = xh_data(ii-1,:);
    if g_data(ii,Nvar+1)<h_data(ii,Nvar+1)
        h_data(ii,:) = g_data(ii,:);
        xh_data(ii,:) = x_data(ii,:);
    end
end

% x0 = (h_data(end,1:Nvar)'-vrange(:,1))./(vrange(:,2)-vrange(:,1));
% for ii=1:Ncnt
%     x1 = (h_data(ii,1:Nvar)'-vrange(:,1))./(vrange(:,2)-vrange(:,1));
%     xh_data(ii,:) = x1(:)';
%     dist(ii) = norm(x1 - x0);
% end

hdata.h_data = h_data;
hdata.xh_data = xh_data;

if strcmp(flag_plot,'plot')
    figure
    a1=subplot(2,1,1)
%     plot(1:Ncnt, g_data(:,Nvar+1),'-',1:Ncnt, h_data(:,Nvar+1),'r-');
    semilogy(1:Ncnt, g_data(:,Nvar+1),'-',1:Ncnt, g_data(:,Nvar+2),'r-')
    ylabel('objective')
    xlabel('cnt')
    %     legend('all', 'best')
    set(gca,'xlim',[1, Ncnt])
    
    
%     a2=subplot(3,1,2)
%     plot(1:Ncnt,hdata.x_data(:,Nvar+2),1:Ncnt,hdata.xh_data(:,Nvar+2),'r')
%     ylabel('distance')
%     xlabel('cnt')
%     set(gca,'xlim',[1, Ncnt])
    
    
    a3=subplot(2,1,2)
    plot(1:Ncnt,hdata.x_data(:,1:Nvar))
    ylabel('parameters')
    xlabel('cnt')
    set(gca,'xlim',[1, Ncnt])
    
    
%     linkaxes([a1,a2,a3],'x');
    linkaxes([a1,a3],'x');
end