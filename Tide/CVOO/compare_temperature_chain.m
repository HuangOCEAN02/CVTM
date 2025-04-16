close all;clc;clear
load ('./obcs/CVOO_temp_100_1000_new.mat')
So_time = datetime(2011,08,01,0,0,0);
Eo_time = datetime(2011,08,31,23,30,0);
xo = [So_time:0.5/24:Eo_time]';

load('./Model/CVOO_temp_100_1000.mat')
Sm_time = datetime(2011,08,01,0,0,0);
Em_time = datetime(2011,08,31,23,59,0);
xm = [Sm_time:60/86400:Em_time]';

dt = minutes(30);
for k = 1:size(TO_inter,1);
    TO_data = timetable(xm,TO_inter(k,:)');
    TO_ana_data = timetable(xm,TO_inter_ana(k,:)');

    TO_inter_halfhour(k,:) =  table2array(retime(TO_data,'regular','linear','TimeStep',dt));
    TO_inter_ana_halfhour(k,:) = table2array(retime(TO_ana_data,'regular','linear','TimeStep',dt));
    clear TO_data TO_ana_data
end
%%
load('./obcs/Temp_chain.mat','time')
x_time = time;clear time;

S_time = datetime(2011,08,01,0,0,0);
E_time = datetime(2011,08,31,23,30,0);
t_s = find ( x_time == S_time);
t_e = find ( x_time == E_time);
TE = length([t_s:t_e]);
formatOut = 'mm-dd';
% hour = hour(x_time([t_s:t_e]));
interval_label = 24*2;
DAY = day(x_time([t_s:interval_label:t_e]));
day_indx = t_s;
for t = 1 : 1 : length(DAY)
    xdate{t} =  datestr(x_time(day_indx),formatOut);
    day_indx = day_indx + interval_label;
end
xx = [t_s:1:t_e];

%%

figure(2);clf;set(gcf,'color','w');
set(gcf,'position',[50 50 1000 800]);
[ha, pos] = tight_subplot(2, 1, [.05 .03],[.1 .02],[.1 .2]);
axes(ha(1))
contourf(XX,YY,T_inter,[3.5,4:1:16],'LineStyle','-','LineWidth',1.5,'color','k');hold on;
% contour(XX,YY,TO_inter_halfhour(:,1:end-1),[3.5,4:1:16],'LineStyle','-','LineWidth',0.5,'color','w');hold on;
clim([3 18])
% % clim([2 18])
% colormap(jet);
% load('ncview_default.mat');colormap(ncview_default)
% load('wh_bl_gr_ye_re.mat');colormap(wh_bl_gr_ye_re)
% load('rainbow_white_gray.mat');colormap(rainbow_white_gray)
load('rainbow_gray.mat');colormap(rainbow_gray)

interval_label = 24*2;
set(ha(1),'fontsize',25,'LineWidth',2,'fontname','Arial',...
'Ydir','reverse','Xaxislocation','bottom','fontweight','bold');   
set(ha(1),'fontsize',25,'XTick',[XX(1,1):interval_label:XX(1,end)],'XTickLabel',{''},'LineWidth',2,'fontname','Arial',...
    'YTick',[0:100:3000],'Ydir','reverse','Xaxislocation','bottom','fontweight','bold');

set(ha(1),'Layer','top');grid off
set(ha(1),'GridLineStyle','-.','GridColor',[.2 .2 .2]','GridAlpha',0.1)

% xlabel('Time','fontsize',10,'fontname','Arial')
ylabel('Depth(m)','fontsize',28,'fontname','Arial')  
axis([XX(1,1) XX(1,end),10 1000])

Left = datetime(2011,08,12,0,0,0);
Right = datetime(2011,08,31,23,30,0);

t_left = find (x_time == Left);
t_right = find (x_time == Right);

set(ha(1),'XLim',[t_left t_right],...
    'YLim',[100 900]);

%%
axes(ha(2))
contourf(XX,YY,TO_inter_halfhour(:,1:end-1),[3.5,5:1:16],'LineStyle','-','LineWidth',1.5,'color','k');hold on;
clim([3 18])
colormap(jet);
% load('rainbow_gray.mat');colormap(rainbow_gray);
colormap(jet);


h2 = colorbar(ha(2),'Position',[0.815500000000001 0.267929634641407 0.0303333333333335 0.580027063599461],'LineWidth',1,...
    'FontSize',25);
set(get(h2,'Title'),'string','°C','fontname','Arial');

cbarrow;
interval_label = 24*2;
set(ha(2),'fontsize',25,'LineWidth',2,'fontname','Arial',...
'Ydir','reverse','Xaxislocation','bottom','fontweight','bold');   
set(ha(2),'fontsize',25,'XTick',[XX(1,1):interval_label:XX(1,end)],'XTickLabel',xdate,'LineWidth',2,'fontname','Arial',...
    'YTick',[0:100:3000],'Ydir','reverse','Xaxislocation','bottom','fontweight','bold');

set(ha(2),'Layer','top');grid off
set(ha(2),'GridLineStyle','-.','GridColor',[.2 .2 .2]','GridAlpha',0.1)

% xlabel('Time','fontsize',10,'fontname','Arial')
ylabel('Depth(m)','fontsize',28,'fontname','Arial')  
axis([XX(1,1) XX(1,end),10 1000])

Left = datetime(2011,08,12,0,0,0);
Right = datetime(2011,08,31,23,30,0);

t_left = find (x_time == Left);
t_right = find (x_time == Right);

set(ha(2),'XLim',[t_left t_right],...
    'YLim',[100 900]);

img=getframe(gcf);
imwrite(img.cdata,['CVOO_Temp_Profile_Compare.tiff'], 'tiff', 'Resolution', 300)
