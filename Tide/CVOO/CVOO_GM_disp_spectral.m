clear;clc;close all
load('./obcs/Temp_chain.mat');
load('./obcs/Sali_chain.mat');

x_time =time;
clear time
% S_time = datetime(2011,07,15,0,0,0);
S_time = datetime(2011,07,01,0,0,0);
E_time = datetime(2012,07,31,23,30,0);

% S_time = datetime(2011,08,01,0,0,0);
% E_time = datetime(2011,08,31,23,30,0);

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
% yy = d_inter(:);
% [XX,YY] = meshgrid(xx,yy);
TT = TO(:,t_s:t_e);
SS = SO(:,t_s:t_e);
%% vertical interpolation
firstLevel = min(mean(depth_SO,2));
lastLevel = max(mean(depth_SO,2));
d_inter = [40:10:1000]'; % vertial grid
T_inter = zeros(size(d_inter,1),size(TT,2));
S_inter = zeros(size(d_inter,1),size(TT,2));
N2_inter= zeros(size(d_inter,1)-1,size(TT,2));
P_inter =sw_pres(d_inter,17.6067);
% vertical fill
for t=1:size(TT,2)
    T_inter(:,t)= ...
        interp1(depth(:,t),TT(:,t),d_inter,'linear');
    S_inter(:,t)= ...
        interp1(depth_SO(:,t),SS(:,t),d_inter,'linear');

    [N2_inter(:,t),~,Np_inter]= sw_bfrq(S_inter(:,t),T_inter(:,t),P_inter);
end

% Temporal fill
    N2_inter2 = zeros(size(N2_inter));
    T_inter2 = zeros(size(N2_inter));
    Mask_tem = zeros(size(N2_inter,1),size(N2_inter,2))+1;
    Mask_tem(isnan(N2_inter)==1)=0;
    for k=1:size(N2_inter2,1)
        clear t_inter ind
         ind =  Mask_tem(k,:);
         [t_s] = find(ind==1);
         t_inter = [t_s(1):1:t_s(end)];
         N2_inter2(k,t_s(1):1:t_s(end))= ...
             fillmissing(N2_inter(k,t_s(1):1:t_s(end)),'linear','SamplePoints',t_inter);
         T_inter2(k,t_s(1):1:t_s(end))= ...
             fillmissing(T_inter(k,t_s(1):1:t_s(end)),'linear','SamplePoints',t_inter);
    end

Mask_tem = zeros(size(N2_inter2,1),size(N2_inter2,2))+1;
Mask_tem(~isnan(N2_inter2))=0;
sum(Mask_tem,"all")

N2_inter = N2_inter2;
T_inter = T_inter2;

clear N2_inter2
Lat_CVOO = 17.6067;
Nd_inter =sw_dpth(Np_inter,Lat_CVOO);
[XX,YY] = meshgrid(xx,Nd_inter);

% N2_inter(N2_inter<=0)=nan;
N2_inter(N2_inter<=1e-6)=1e-6;
figure(1);clf;set(gcf,'color','w');
set(gcf,'position',[50 50 500 350]);
% pcolor(XX,YY,T_inter_ana);shading interp;hold on;
% pcolor(XX,YY,N2_inter);shading interp;hold on;
% clim([1e-6 3e-4])
%% background
N2_Profile_mean = nanmean(N2_inter,2);
Z_Profile = Np_inter;
N2_Profile_mean(N2_Profile_mean<=1e-6)=1e-6;
T_inter_mean = nanmean(T_inter,2);
% plot(N2_Profile_mean,Z_Profile);ylog

strain_from_N2 = zeros(size(N2_inter));
for t = 1:size(N2_inter,2)
    strain_from_N2(:,t) = (N2_inter(:,t) - N2_Profile_mean)./mean(N2_inter(:,t));
    Yita(:,t) = (T_inter(:,t) - T_inter_mean)./(gradient(T_inter_mean)./10);
end

% pcolor(XX,YY,Yita);shading interp;hold on;
% clim([-20 20]);colormap('turbo')

%% GM
params= Gm76Params;
params.Ef=0.5;
params.N0 = 5.23e-3; 
dt = 1800/86400; %Sampling interval dt in days
% f max: (1/dt)/2;
% f min: 1/(length(cv)*dt)

figure(1);clf;set(gcf,'position',[10 10 700 450]);
set(gcf,'Color','w')

count = 0;
spp_ave = 0;
N_ave = 0;
% for k_level=40:1:77
for k_level=27:1:47
    % k_level = 46;
    % Nd_inter(k_level)
    % cv = strain_from_N2(k_level,:);
    % 
    d_inter(k_level)
    cv = Yita(k_level,:);
    N_level = sqrt(N2_Profile_mean(k_level));
    
    cv = cv';
    P=8;K=7;% 7
    psi=sleptap(length(cv),P,K); 
    
    [f,spp,~] = mspec(dt,cv,psi,'cyclic'); %specify to mspec to output cyclic frequencies
    count = count + 1;
    spp_ave = spp_ave + spp*N_level/params.N0;
    % N_ave = N_ave + N_level;
end
spp_ave = spp_ave./count;
% N_ave = N_ave./count;
% spp_ave = spp_ave.*N_ave/params.N0;

% f = f./86400; % cpm
% spp=spp.*86400; % (m/s)^2 * second

    h=plot(f,spp_ave);xlim([f(2) f(end)]),xlog,ylog;
    % ylim(10.^([-4 -1.8]))
    set(h(1),'linewidth',1.5,'color','k');hold on

    [ra,rb]=mconf(2*P-1,0.95,'log10'); %compute confidence intervals
    h_ci=plot(f,[10^ra 10^rb].*spp_ave);linestyle(h_ci,'C-')
    set(h_ci,'LineWidth',1.0)
%% GM

    fcor = sw_f(Lat_CVOO);
    f_GM_start = f(2) *2*pi/86400 ; %rad/s
    f_GM_end = f(end) *2*pi/86400;
    
    % N = f_GM_end;
    om = linspace(f_GM_start,f_GM_end,1000); % rad/s

    S_GM=0;
    count = 0;
for k_level=27:1:47
    N_level = sqrt(N2_Profile_mean(k_level));
    S = GmOm('dis',om,fcor,N_level,params); % (m/s)^2 * rad/s
    
    % S = S.* (params.N0)./N_level;
    % S = S.* max(sqrt(N2(:)))./N_level;
    S_GM = S_GM + S.*N_level/params.N0;
    count = count + 1;
end
    S_GM = S_GM/count;

    om = om.*86400/(2*pi); % 
    S_GM = S_GM *(2*pi)/86400;
    
    hold on;
    h_GM=plot(om,S_GM,'LineWidth',2,'color','b','LineStyle','-.');

    xlim([om(1) om(end)])
    % vlines(N_level.*86400/(2*pi),':');

xlim([0.4 om(end)])
vlines(corfreq(Lat_CVOO)/2/pi*24,'2r--')
vlines(tidefreq('m2')/2/pi*24,'2--');
vlines(tidefreq('s2')/2/pi*24,'1--');
vlines((tidefreq('m2')+tidefreq('k1'))/2/pi*24,'1--');
% vlines((2*tidefreq('m2')+tidefreq('k1'))/2/pi*24,'1--');
vlines(tidefreq('k1')/2/pi*24,'2--');
vlines(tidefreq('O1')/2/pi*24,'1--');
vlines(2*tidefreq('m2')/2/pi*24,'1--');
vlines(3*tidefreq('m2')/2/pi*24,'1--');
xlim(10.^([-0.5 1.0]))
    ylim(10.^([-1 3]))


grid on;

set(gca,'fontsize',25,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold');   
set(gca,'fontsize',25,'XTick',[10^0,10^1],'LineWidth',1,'fontname','Arial',...
    'Xaxislocation','bottom')

set(gca,'Layer','top');
% set(gca,'GridLineStyle','-.','GridColor',[.2 .2 .2]','GridAlpha',0.1)

ylabel(['$\phi\ ','N/N_{0}','\ (m^2\ cpd^{-1})$'],'fontsize',28,'Interpreter','latex')
xlabel('Frequency (cpd)','fontsize',28,'fontname','Arial')  

frame=getframe(gcf);
imind=frame2im(frame);

[imind,cm] = rgb2ind(imind,256);
set(gca,'fontsize',25,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold');  

 img=getframe(gcf);
 imwrite(img.cdata,['CVOO_disp_300_500m_GM.tiff'], 'tiff', 'Resolution', 300)


