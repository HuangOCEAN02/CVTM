clear;clc;close all
% load('M2_BC_tide_pressure.mat')
load('M2_BC_tide_pbt.mat')
%% BT
load('../Tide/res_uso_level1_CV.mat')
uam = amph(:,4);
uph = gphh(:,4);
lonu = lono;
latu = lato;
clear lono lato amph amph
%% BT
load('../Tide/res_vse_level1_CV.mat')
vam = amph(:,4);
vph = gphh(:,4);
lonv = lono;
latv = lato;
clear lono lato amph gphh
%% Model GRID & background stratification 
addpath ../Model_info/
load('Grid_info.mat','ke','weto_p','latp_grid','depto_grid','lonp_grid','bottom_index');
% load('Grid_info_u.mat', 'deuto_grid','dduo_grid');
% load('Grid_info_v.mat', 'deute_grid','ddue_grid');
load('Grid_resolution.mat', 'dlyv','dlxu');

iw = 30;ie = 1;
jn = 30;js = 30;

weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);

bottom_index = Exclude_sponge(iw,ie,jn,js,bottom_index);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);

% dduo_grid  = Exclude_sponge(iw,ie,jn,js,dduo_grid);
% deuto_grid  = Exclude_sponge(iw,ie,jn,js,deuto_grid);
% 
% ddue_grid  = Exclude_sponge(iw,ie,jn,js,ddue_grid);
% deute_grid  = Exclude_sponge(iw,ie,jn,js,deute_grid);

dlxu  = Exclude_sponge(iw+1,ie,jn,js,dlxu);
dlyv  = Exclude_sponge(iw,ie,jn+1,js,dlyv);


ie = size(depto_grid,1);
je = size(depto_grid,2);

uam = reshape(uam,ie+1,je); 
uph = reshape(uph,ie+1,je);

vam = reshape(vam,ie,je+1);
vph = reshape(vph,ie,je+1);

%% wbt
C = zeros(ie,je);
depto_grid(539,405) = nanmean(depto_grid(538:540,404:406),'all');

[dHy,dHx] = gradient(-depto_grid);
dHx = dHx./dlxu;
dHy = -dHy./dlyv;

for i = 1 : ie
    for j = 1 : je
        if weto_p(i,j,1)~=0
        % C(i,j) = (1/2) * pa(i,j,bottom_index(i,j)) * ((uam(i,j)+uam(i+1,j))/2.0) * ...
        %     cosd(((uph(i,j)+uph(i+1,j))/2.0) - pg(i,j,bottom_index(i,j))) * ...
        %     dHx(i,j) + ...
        %         (1/2) * pa(i,j,bottom_index(i,j)) * ((vam(i,j)+vam(i,j+1))/2.0) * ...
        %     cosd(((vph(i,j)+vph(i,j+1))/2.0) - pg(i,j,bottom_index(i,j))) * ...
        %     dHy(i,j);

        C(i,j) = (1/2) * pa(i,j) * ((uam(i,j)+uam(i+1,j))/2.0) * ...
            cosd(((uph(i,j)+uph(i+1,j))/2.0) - pg(i,j)) * ...
            dHx(i,j) + ...
                (1/2) * pa(i,j) * ((vam(i,j)+vam(i,j+1))/2.0) * ...
            cosd(((vph(i,j)+vph(i,j+1))/2.0) - pg(i,j)) * ...
            dHy(i,j);
        end
    end
end

C(539,405) = nanmean(C(538:540,404:406),'all'); % land mask

save ./M2_tide/M2_conversion.mat C
