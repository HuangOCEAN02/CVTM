clear;clc;close all
Lon_CVOO = -24.2497;
Lat_CVOO = 17.6067;
%%
load('./obcs/U_ADCP_1D.mat','uo')
load('./obcs/V_ADCP_1D.mat','vo')
load('./Model/CVOO_M2_tide_hourly.mat','u_all_100m','v_all_100m')
%% U
 % x = uo-mean(uo); % observation
 % y = u_all_100m-mean(u_all_100m);

 y = uo-mean(uo); % observation
 x = u_all_100m-mean(u_all_100m);

 x = x';
 data = [x,y];
 dataNums = length(x);
% density
density_2D = ksdensity(data,data);

a=0;
b=1;

Ymax = max(density_2D);
Ymin = min(density_2D);

k=(b-a)/(Ymax-Ymin);

density_2D = a + k*(density_2D-Ymin);

% density_2D = normalize(density_2D);

figure(1);clf;set(gcf,'color','w');
set(gcf,'position',[50 50 500 500])
h1 = scatter(x,y,10,density_2D,'filled');
% d = colorbar('ticklength',0)
colormap("turbo");
% clim([0 1])
% ax=gca;
% axpos=ax.Position;
% d.Position(3) = 0.5*d.Position(3);
% ax.Position = axpos;
% cbarrow;
hold on;
box on;

% x1 = smoothdata(x);
% y1 = smoothdata(y);

x1 = x;
y1 = y;

pcoef = polyfit(x1,y1,1);
yfited = polyval(pcoef,x1);

h2 = plot(x1,yfited,'color','k','LineWidth',2);
mdl=fitlm(x,y);

R2 = num2str(sprintf('%0.3f',mdl.Rsquared.Ordinary));
a = num2str(sprintf('%0.3f',pcoef(1)));
b = num2str(sprintf('%0.3f',pcoef(2)));

BIAS = mean(x1-y1);
MSE = immse(x1,y1);
RMSE = sqrt(MSE);

labtxt1  = ['$y = $',a,'$x+$','(',b,')'];
labtxt2  = [' $N = $',num2str(dataNums)];
labtxt3  = ['$R^2 = $ ',R2];
labtxt4  = ['$RMSE = $',num2str(sprintf('%0.3f',RMSE))];



text(min(x1)+0.01,max(yfited),labtxt1, ...
    'Color','k','FontSize',20, ...
    'fontname','Arial','fontweight','bold','Interpreter','latex');

text(min(x1)+0.01,max(yfited)-0.01,labtxt2, ...
    'Color','k','FontSize',20, ...
    'fontname','Arial','fontweight','bold','Interpreter','latex');

text(min(x1)+0.01,max(yfited)-0.02,labtxt3, ...
    'Color','k','FontSize',20, ...
    'fontname','Arial','fontweight','bold','Interpreter','latex');

text(min(x1)+0.01,max(yfited)-0.03,labtxt4, ...
    'Color','k','FontSize',20, ...
    'fontname','Arial','fontweight','bold','Interpreter','latex');

legend([h1,h2],{'Tidal velocity','Fiting line'},...
    'Location','southeast','FontSize',20,'Box','on',...
    'fontname','Arial','fontweight','bold');


grid on
set(gca,'GridAlpha',0.4,'GridLineWidth',0.5,'GridLineStyle','-.')
set(gca,'linewidth',2,'fontsize',25,'fontname','Arial','fontweight','bold');
set(gca,'linewidth',2,'fontsize',25,'fontname','Arial','fontweight','bold');

set(gca,'linewidth',2,'fontsize',25,'fontname','Arial','fontweight','bold');

xlabel('Model','fontsize',28,'fontname','Arial','fontweight','bold');
ylabel('Observation','fontsize',28,'fontname','Arial','fontweight','bold');
xlim([-0.07 0.1])
ylim([-0.06 0.06])

img=getframe(gcf);
imwrite(img.cdata,['CVOO_U100m_LinearFit.tiff'], 'tiff', 'Resolution', 300)
%%
 % x = vo-mean(vo); % observation
 % y = v_all_100m-mean(v_all_100m);
 y = vo-mean(vo); % observation
 x = v_all_100m-mean(v_all_100m);

x = x';
 data = [x,y];
 dataNums = length(x);
% density
density_2D = ksdensity(data,data);

a=0;
b=1;

Ymax = max(density_2D);
Ymin = min(density_2D);

k=(b-a)/(Ymax-Ymin);

density_2D = a + k*(density_2D-Ymin);

% density_2D = normalize(density_2D);

figure(1);clf;set(gcf,'color','w');
set(gcf,'position',[50 50 500 500])
h1 = scatter(x,y,10,density_2D,'filled');
% d = colorbar('ticklength',0)
colormap("turbo");
% clim([0 1])
% ax=gca;
% axpos=ax.Position;
% d.Position(3) = 0.5*d.Position(3);
% ax.Position = axpos;
% cbarrow;
hold on;
box on;

% x1 = smoothdata(x);
% y1 = smoothdata(y);

x1 = x;
y1 = y;

pcoef = polyfit(x1,y1,1);
yfited = polyval(pcoef,x1);

h2 = plot(x1,yfited,'color','k','LineWidth',2);
mdl=fitlm(x,y);

R2 = num2str(sprintf('%0.3f',mdl.Rsquared.Ordinary));
a = num2str(sprintf('%0.3f',pcoef(1)));
b = num2str(sprintf('%0.3f',pcoef(2)));

BIAS = mean(x1-y1);
MSE = immse(x1,y1);
RMSE = sqrt(MSE);

% labtxt  = [' N = ',num2str(dataNums),' R^2 = ',R2 ...
%        newline ' y = ',a,'x + ',b...
%        newline ' RMSE = ',num2str(RMSE)];
% text(min(x1)+0.01,max(yfited)-0.01,labtxt, ...
%     'Color','k','FontSize',12, ...
%     'fontname','Arial','fontweight','bold');


labtxt1  = ['$y = $',a,'$x+$','(',b,')'];
labtxt2  = [' $N = $',num2str(dataNums)];
labtxt3  = ['$R^2 = $ ',R2];
labtxt4  = ['$RMSE = $',num2str(sprintf('%0.3f',RMSE))];

text(min(x1)+0.01,max(yfited),labtxt1, ...
    'Color','k','FontSize',20, ...
    'fontname','Arial','fontweight','bold','Interpreter','latex');

text(min(x1)+0.01,max(yfited)-0.01,labtxt2, ...
    'Color','k','FontSize',20, ...
    'fontname','Arial','fontweight','bold','Interpreter','latex');

text(min(x1)+0.01,max(yfited)-0.02,labtxt3, ...
    'Color','k','FontSize',20, ...
    'fontname','Arial','fontweight','bold','Interpreter','latex');

text(min(x1)+0.01,max(yfited)-0.03,labtxt4, ...
    'Color','k','FontSize',20, ...
    'fontname','Arial','fontweight','bold','Interpreter','latex');
% legend([h1,h2],{'Tidal velocity','Fiting line'},...
%     'Location','southeast','FontSize',12,'Box','on',...
%     'fontname','Arial','fontweight','bold');



grid on
set(gca,'GridAlpha',0.4,'GridLineWidth',0.5,'GridLineStyle','-.')
set(gca,'linewidth',2,'fontsize',25,'fontname','Arial','fontweight','bold');
set(gca,'linewidth',2,'fontsize',25,'fontname','Arial','fontweight','bold');
set(gca,'linewidth',2,'fontsize',25,'fontname','Arial','fontweight','bold');

xlabel('Model','fontsize',28,'fontname','Arial','fontweight','bold');
ylabel('Observation','fontsize',28,'fontname','Arial','fontweight','bold');
xlim([-0.1 0.15])
ylim([-0.07 0.1])
img=getframe(gcf);
imwrite(img.cdata,['CVOO_V100m_LinearFit.tiff'], 'tiff', 'Resolution', 300)
