clear;clc;close all
load('./obcs/CVOO_Tidal_Constants.mat')
load('./obcs/ADCP_10_U.mat')
load('./obcs/ADCP_10_V.mat')
load('./obcs/BuoyancyFreq_above100m.mat');
Lat_CVOO = 17.6067;
N2 = interp1(Z_Profile,N2_Profile_mean,d_inter,"linear");
%% BT predict
base_date = datenum(x_time(1));
end_date = datenum(x_time(end));
SDtime = [base_date:1/24:end_date];
% 
% USO_Ttide(:)=t_predic(SDtime,NAME_bt([3,4,6,10,11,12],:), ...
%     FREQ_bt([3,4,6,10,11,12]), res_uso([3,4,6,10,11,12],:));
% VSE_Ttide(:)=t_predic(SDtime,NAME_bt([3,4,6,10,11,12],:), ...
%     FREQ_bt([3,4,6,10,11,12]), res_vse([3,4,6,10,11,12],:));


USO_Ttide(:)=t_predic(SDtime,NAME_bt(:,:), ...
    FREQ_bt(:), res_uso);
VSE_Ttide(:)=t_predic(SDtime,NAME_bt(:,:), ...
    FREQ_bt(:), res_vse);

%% low-filter
% figure(1)
% plot(u_grid(1,:)- USO_Ttide,'r');hold on;

S_time = datenum(2011,07,01,0,0,0);
E_time = datenum(2012,07,31,23,0,0);
% E_time = datenum(2011,08,31,23,0,0);

% S_time = datenum(2011,08,01,0,0,0);
% E_time = datenum(2011,08,31,23,0,0);

t_s = find (x_time == datetime(S_time,'ConvertFrom','datenum'));
t_e = find (x_time == datetime(E_time,'ConvertFrom','datenum'));

t_se = [t_s:1:t_e]; te = length(t_se);
%%
dt = 3600/86400; %Sampling interval dt in days
ke_point = size(v_grid,1);
uko_time = u_grid(:,t_s:t_e);
vke_time = v_grid(:,t_s:t_e);

Lat_mooring = 17.29985;
params= Gm76Params;
% params.jstar=6;
params.Ef=0.5;
% N=5.23e-3     % 3cph = (3).*24 cpd
params.N0 =5.23e-3 ; 

% find the b
% figure(1);clf
% scatter(d_inter,sqrt(N2(:)));hold on;
% plot(d_inter,linspace(max(sqrt(N2(:)))*exp(-1),max(sqrt(N2(:)))*exp(-1),length(d_inter)));hold on;
% params.b = 23; % 23m
% params.N0 =max(sqrt(N2(:)));
%%  average
dt = 3600/86400; %Sampling interval dt in days
% f max: (1/dt)/2;
% f min: 1/(length(cv)*dt)
figure(1);clf;set(gcf,'position',[10 10 700 450]);
set(gcf,'Color','w')
for k_level=length(d_inter):1:length(d_inter)
% k_level = 46;
d_inter(k_level)
cv = uko_time(k_level,:);
N_level = sqrt(N2(k_level));

cv = cv';
P=8;K=7;% 7
psi=sleptap(length(cv),P,K); 

[f,spp_u,~] = mspec(dt,cv,psi,'cyclic'); %specify to mspec to output cyclic frequencies

cv = vke_time(k_level,:);
cv = cv';

[f,spp_v,~] = mspec(dt,cv,psi,'cyclic'); %specify to mspec to output cyclic frequencies

spp = spp_u + spp_v; % (m/s)^2 * days

spp = spp.* (params.N0)./N_level;


% f = f./86400; % cpm
% spp=spp.*86400; % (m/s)^2 * second

    h=plot(f,spp);xlim([f(2) f(end)]),xlog,ylog;
    % ylim(10.^([-4 -1.8]))
    set(h(1),'linewidth',1.5,'color','k');hold on

    [ra,rb]=mconf(2*P-1,0.95,'log10'); %compute confidence intervals
    h_ci=plot(f,[10^ra 10^rb].*spp);linestyle(h_ci,'C-')
    set(h_ci,'LineWidth',1.0)
%% GM
    fcor = sw_f(Lat_CVOO);
    f_GM_start = f(2) *2*pi/86400 ; %rad/s
    f_GM_end = f(end) *2*pi/86400;
    
    % N = f_GM_end;
    om = linspace(f_GM_start,f_GM_end,1000); % rad/s
    S = GmOm('Vel',om,fcor,N_level,params); % (m/s)^2 * rad/s
    
    S = S.* (params.N0)./N_level;
    % S = S.* max(sqrt(N2(:)))./N_level;
    om = om.*86400/(2*pi); % 
    S = S *(2*pi)/86400;
    
    hold on;
    h_GM=plot(om,S,'LineWidth',2,'color','b','LineStyle','-.');

    xlim([om(1)/3 om(end)])
    % vlines(N_level.*86400/(2*pi),':');
end
    xlim(10.^([-0.5 1.0]))
    ylim(10.^([-5 -2]))
vlines(corfreq(Lat_CVOO)/2/pi*24,'2r--')
vlines(tidefreq('m2')/2/pi*24,'2--');
vlines(tidefreq('s2')/2/pi*24,'1--');
% vlines(tidefreq('n2')/2/pi*24,'2--');
vlines((tidefreq('m2')+tidefreq('k1'))/2/pi*24,'1--');
% vlines((2*tidefreq('m2')+tidefreq('k1'))/2/pi*24,'1--');
vlines(tidefreq('K1')/2/pi*24,'2--');
vlines(tidefreq('O1')/2/pi*24,'1--');
vlines(2*tidefreq('m2')/2/pi*24,'1--');
vlines(3*tidefreq('m2')/2/pi*24,'1--');

% vlines((tidefreq('m2')-corfreq(Lat_CVOO))/2/pi*24,'1--');

grid on;

set(gca,'fontsize',25,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold');   
set(gca,'fontsize',25,'XTick',[10^0,10^1],'LineWidth',1,'fontname','Arial',...
    'Xaxislocation','bottom')

set(gca,'Layer','top');
% set(gca,'GridLineStyle','-.','GridColor',[.2 .2 .2]','GridAlpha',0.1)

ylabel(['$\phi\ ','N_{0}/N','\ (m^2\ s^{-2}\ cpd^{-1})$'],'fontsize',28,'Interpreter','latex')
xlabel('Frequency (cpd)','fontsize',28,'fontname','Arial')  

frame=getframe(gcf);
imind=frame2im(frame);
[imind,cm] = rgb2ind(imind,256);
set(gca,'fontsize',25,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold');  

img=getframe(gcf);
imwrite(img.cdata,['CVOO_100m_GM.tiff'], 'tiff', 'Resolution', 300)


