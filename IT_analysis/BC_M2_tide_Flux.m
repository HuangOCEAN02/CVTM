clear;clc;close all
load('M2_BC_tide_velocity.mat')
load('M2_BC_tide_pressure.mat')
%%
load('Grid_info.mat','ke','weto_p','depto_grid','ddpo_grid','zzout','bottom_index');
load('Grid_info_u.mat','weto_u','latu_grid','lonu_grid');
load('Grid_info_v.mat','weto_v','latv_grid','lonv_grid');

iw = 30;ie = 1;
jn = 30;js = 30;

depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
ddpo_grid = Exclude_sponge(iw,ie,jn,js,ddpo_grid);
zzout = Exclude_sponge(iw,ie,jn,js,zzout);
bottom_index =  Exclude_sponge(iw,ie,jn,js,bottom_index);

weto_u  = Exclude_sponge(iw,ie,jn,js,weto_u);
weto_v  = Exclude_sponge(iw,ie,jn,js,weto_v);
weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);

ie = size(depto_grid,1);
je = size(depto_grid,2);
%% Flux_x
Flux_x = zeros(ie,je);
Flux_y = zeros(ie,je);

Flux_x_tide = zeros(ie,je,ke);
Flux_y_tide = zeros(ie,je,ke);

Flux_x_tide(1:end,:,:) =  ...
    ( ((ua(1:1:end-1,:,:)+ua(2:1:end,:,:))/2).* ...
       pa(1:end,:,:).*...
    cosd (((ug(1:1:end-1,:,:)+ug(2:1:end,:,:))/2) - pg(1:end,:,:) ) );

Flux_y_tide(:,1:end,:) =  ...
    ( ((va(:,1:1:end-1,:)+va(:,2:1:end,:))/2).* ...
    pa(:,1:end,:).* ...
    cosd (((vg(:,1:1:end-1,:)+vg(:,2:1:end,:))/2) - pg(:,1:end,:) ) );

Flux_x_tide(weto_p==0)=0;
Flux_y_tide(weto_p==0)=0;

% vertical intergration
Flux_x = ((sum(Flux_x_tide.*ddpo_grid,3))./depto_grid);
Flux_y = ((sum(Flux_y_tide.*ddpo_grid,3))./depto_grid);

save ./M2_tide/M2_Flux.mat Flux_x Flux_y Flux_x_tide Flux_y_tide

% save M2_Flux_method1.mat Flux_x Flux_y