%% Model GRID INFO 
%% Save *.mat
clear;close all;clc
diagnosis = 1;
%%
ie_g=817;  je_g=619;  ke = 40;
IE_G = ie_g*2+1;   JE_G = je_g*2+1;
depto = double(ncread('GRID_INFO.nc','var200'));
depto_grid = reshape(depto,ie_g,je_g);
depto_grid(depto_grid==0)=nan;

lonp = double(ncread('GRID_INFO.nc','var110'));
lonp_grid = reshape(lonp,ie_g,je_g);

latp = double(ncread('GRID_INFO.nc','var120'));
latp_grid = reshape(latp,ie_g,je_g);

lonu = double(ncread('GRID_INFO.nc','var111'));
lonu_grid = reshape(lonu,ie_g+1,je_g);

latu = double(ncread('GRID_INFO.nc','var121'));
latu_grid = reshape(latu,ie_g+1,je_g);

lonv = double(ncread('GRID_INFO.nc','var112'));
lonv_grid = reshape(lonv,ie_g,je_g+1);

latv = double(ncread('GRID_INFO.nc','var122'));
latv_grid = reshape(latv,ie_g,je_g+1);

deuto = double(ncread('GRID_INFO.nc','var201'));
deuto_grid = reshape(deuto,ie_g+1,je_g);
deuto_grid (deuto_grid==0)=nan;

deute = double(ncread('GRID_INFO.nc','var202'));
deute_grid = reshape(deute,ie_g,je_g+1);
deute_grid (deute_grid==0)=nan;


weto_p = double(ncread('GRID_INFO.nc','var300'));
weto_p = reshape(weto_p,[ie_g,je_g,ke]);
weto_p = double(squeeze(weto_p));


weto_u = double(ncread('GRID_INFO.nc','var301'));
weto_u = double(squeeze(weto_u));
weto_u = reshape(weto_u,[ie_g+1,je_g,ke]);
weto_u = double(squeeze(weto_u));

weto_v = double(ncread('GRID_INFO.nc','var302'));
weto_v = double(squeeze(weto_v));
weto_v = reshape(weto_v,[ie_g,je_g+1,ke]);
weto_v = double(squeeze(weto_v));

DDPO = double(ncread('GRID_INFO.nc','var430'));
ddpo_grid = reshape(DDPO,ie_g,je_g,ke);
ddpo_grid = squeeze(ddpo_grid);

DDUO = double(ncread('GRID_INFO.nc','var431'));
dduo_grid = reshape(DDUO,ie_g+1,je_g,ke);
dduo_grid = squeeze(dduo_grid);

DDUE = double(ncread('GRID_INFO.nc','var432'));
ddue_grid = reshape(DDUE,ie_g,je_g+1,ke);
ddue_grid = squeeze(ddue_grid);

%%
dlxp = double(ncread('GRID_INFO.nc','var410'));
dlxp = reshape(dlxp,ie_g,je_g);

dlxu = double(ncread('GRID_INFO.nc','var411'));
dlxu = reshape(dlxu,ie_g+1,je_g);

dlxv = double(ncread('GRID_INFO.nc','var412'));
dlxv = reshape(dlxv,ie_g,je_g+1);

dlyp = double(ncread('GRID_INFO.nc','var420'));
dlyp = reshape(dlyp,ie_g,je_g);

dlyu = double(ncread('GRID_INFO.nc','var421'));
dlyu = reshape(dlyu,ie_g+1,je_g);

dlyv = double(ncread('GRID_INFO.nc','var422'));
dlyv = reshape(dlyv,ie_g,je_g+1);

% !:: PETERSPY: ICODE (ABC)
% !     A: 1-> lon/lat 2 -> water depth; 3 -> sea mask; 4 -> grid interval
% !     B: 0 -> no direction; 1/2/3 -> X/Y/Z direction
% !     C: 0/1/2 -> variable locates at P/U/V point
% !

% vertical index
bottom_index = zeros(ie_g,je_g);
for i = 1:ie_g
    for j = 1:je_g
        if(weto_p(i,j,1) == 1)
            bottom_index(i,j) = sum(weto_p(i,j,:));
        else
            bottom_index(i,j) = 0;
        end
    end
end

% sumtiefe = zeros(ie_g,je_g);
zzout = zeros(size(ddpo_grid));
zzout_u = zeros(size(dduo_grid));
zzout_w = zeros(ie_g,je_g,ke+1);
% tiefe = zeros(ie_g,je_g);

for i = 1:ie_g
    for j =1:je_g
        if squeeze(weto_p(i,j,1)) ~= 0
        sumtiefe = 0;
        tiefe = 0;
          for k = 1:bottom_index(i,j)
            tiefe = ddpo_grid(i,j,k);
            zzout(i,j,k) = sumtiefe + tiefe/2;
    
            sumtiefe = sumtiefe + tiefe;
            zzout_w(i,j,k+1) = sumtiefe;          
          end
        end
    end
end

for i =1:ie_g+1
    for j = 1:je_g
        if squeeze(weto_u(i,j,1)) ~= 0
            sumtiefe = 0;
            tiefe = 0;
            for k = 1:ke
                tiefe = dduo_grid(i,j,k);
                zzout_u(i,j,k) = sumtiefe + tiefe/2;
                sumtiefe = sumtiefe + tiefe;
            end

        end
    end
end

zzout_u(weto_u==0)=0;

i = 1
j=298
squeeze(ddpo_grid(i,j,1:bottom_index(i,j)))
squeeze(weto_p(i,j,1:bottom_index(i,j)))
squeeze(zzout(i,j,1:bottom_index(i,j)))
zzout(weto_p==0)=0;


save Grid_info_w.mat zzout zzout_w bottom_index
save Grid_info.mat ie_g je_g ke lonp_grid latp_grid zzout zzout_w weto_p depto_grid ddpo_grid bottom_index
save Grid_info_u.mat ie_g je_g ke lonu_grid latu_grid weto_u zzout_u deuto_grid dduo_grid 
save Grid_info_v.mat ie_g je_g ke lonv_grid latv_grid weto_v deute_grid ddue_grid 
save Grid_resolution.mat dlxp dlyp dlxu dlyu dlxv dlyv

%%
base_date=datenum(2011,07,01,0,0,0);
End_date=datenum(2011,08,31,23,00,0);
ncdump = 3600; % time(s) dump
SDtime=[base_date:ncdump/86400:End_date];
time_index = datevec(SDtime);

day=31+31; % all days
run_perhour = 60*60/ncdump; % timesteps per one hour
run_perday = 24*60*60/ncdump; % timesteps per one day
te = day*24*60*60/ncdump;  % all timesteps

dt = 60;
LDTRUN = [0:ncdump/dt:(te-1)*ncdump/dt]; % 2 month: Jul Aug
% t_index usage: One day : From t_index(tt)+1 to t_index(tt+1)

%% find 8 month
S_time=datenum(2011,07,01,0,0,0);
E_time=datenum(2011,08,31,23,00,0);
t_s = find(SDtime==S_time);
t_e =find(SDtime==E_time);


save Time_info.mat dt ncdump run_perday run_perhour te LDTRUN time_index SDtime

%% diagnosis time info
if (diagnosis)
    base_date=datenum(2011,07,01,0,0,0);
    End_date=datenum(2011,08,31,23,59,0);
    day=31+31; % all days
    ncdump = 60; % time(s) dump
    run_perhour = 60*60/ncdump; % timesteps per one hour
    run_perday = 24*60*60/ncdump; % timesteps per one day
    te = day*24*60*60/ncdump;  % all timesteps
    SDtime=[base_date:ncdump/86400:End_date];
    for tt = 0 : te/24/run_perhour;
        t_index(tt+1) = tt*run_perday;
    end
    save Diag_info.mat day ncdump run_perday run_perhour te t_index SDtime
    
    % delZ = [ linspace(10,10,50),linspace(20,20,25),linspace(50,50,19),...
    %          linspace(100,100,9),linspace(250,250,10)];    
    % max_level = sum(delZ)
    % p_pe = reshape([0:1:539],[36,15]);
    run diaginput.m
end