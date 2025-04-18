clear;clc;close all
load('M2_BC_tide_velocity.mat')
load('M2_BC_tide_pressure.mat')
%%
addpath ../Model_info/
load('Grid_info.mat','ke','weto_p','depto_grid','zzout','bottom_index');
load('Grid_info_u.mat','dduo_grid','deuto_grid');
load('Grid_info_v.mat','ddue_grid','deute_grid');
load('Grid_resolution.mat','dlxp','dlyp','dlyu','dlxv');

iw = 30;ie = 1;
jn = 30;js = 30;

depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
deuto_grid  = Exclude_sponge(iw,ie,jn,js,deuto_grid);
deute_grid  = Exclude_sponge(iw,ie,jn,js,deute_grid);


zzout = Exclude_sponge(iw,ie,jn,js,zzout);
bottom_index =  Exclude_sponge(iw,ie,jn,js,bottom_index);

weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);

dduo_grid  = Exclude_sponge(iw,ie,jn,js,dduo_grid);
ddue_grid  = Exclude_sponge(iw,ie,jn,js,ddue_grid);

dlxp  = Exclude_sponge(iw,ie,jn,js,dlxp);
dlyp  = Exclude_sponge(iw,ie,jn,js,dlyp);
dlyu  = Exclude_sponge(iw,ie,jn,js,dlyu);
dlxv  = Exclude_sponge(iw,ie,jn,js,dlxv);

ie = size(depto_grid,1);
je = size(depto_grid,2);

pg(:,:,ke+1)=[];
pa(:,:,ke+1)=[];
%% Flux_x
Flux_x = zeros(ie,je);
Flux_y = zeros(ie,je);

Flux_x_tide = zeros(ie,je,ke);
Flux_y_tide = zeros(ie,je,ke);

 % upstream scheme
 % We exclude the boundary up' and vp'
 % up(1:end-1,:) refers to UOO(1:end-1,:) ie,je
 % up(:,1:end-1) refers to VOE(:,1:end-1) ie,je
 % hence,Flux_x(end,:)=0; Flux_y(:,end)=0
Up = zeros(je,ke);
Dn = zeros(je,ke);
for i = 1: ie-1
    Up(:,:) = ua(i+1,:,:).* pa(i,:,:).* ...
            cosd (ug(i+1,:,:) - pg(i,:,:)).*dduo_grid(i+1,:,:);
    
    Dn(:,:) =  ua(i+1,:,:).* pa(i+1,:,:).* ...
            cosd (ug(i+1,:,:) - pg(i+1,:,:)).*dduo_grid(i+1,:,:);

    Flux_x_tide(i,:,:) = Up(:,:).* (Up(:,:)>0) + Dn(:,:).* (Dn(:,:)<0);
end

Lf = zeros(ie,ke);
Rg = zeros(ie,ke);
for j = 1: je-1

    Lf(:,:) = va(:,j+1,:).* pa(:,j,:).* ...
            cosd (vg(:,j+1,:) - pg(:,j,:)).*ddue_grid(:,j+1,:);

    Rg(:,:) = va(:,j+1,:).* pa(:,j+1,:).* ...
            cosd (vg(:,j+1,:) - pg(:,j+1,:)).*ddue_grid(:,j+1,:);

    Flux_y_tide(:,j,:) = Lf(:,:).* (Lf(:,:)>0) + Rg(:,:).* (Rg(:,:)<0);
end

% Flux_x_tide(weto_p==0)=0;
% Flux_y_tide(weto_p==0)=0;

% vertical intergration
Flux_x = 0.5*((sum(Flux_x_tide,3))./deuto_grid(2:1:end,:));
Flux_y =  0.5*((sum(Flux_y_tide,3))./deute_grid(:,2:1:end));

save M2_Flux.mat Flux_x Flux_y Flux_x_tide Flux_y_tide

% save M2_Flux_method2.mat Flux_x Flux_y
% Re-grid and unit conversion
Fu = zeros(ie+1,je);
Fv = zeros(ie,je+1);

Fu(2:end-1,:) = Flux_x(1:end-1,:); % U-grid
Fv(:,2:end-1) = Flux_y(:,1:end-1); % V-grid

Fu = Fu.*deuto_grid; % units: W/m
Fv = Fv.*deute_grid; % units: W/m

% Divergence
Div_F = zeros(ie,je);
% x-direction
for i = 2 : ie-1
    for j = 2 : je-1
        Div_F(i,j) = ((Fu(i+1,j)*dlyu(i+1,j) - Fu(i,j)*dlyu(i,j)) + ...
                     (Fv(i,j)*dlxv(i,j) - Fv(i,j+1)*dlxv(i,j+1)))./ ...
                       (dlyp(i,j).*dlxp(i,j));
    end
end



save ./M2_tide/M2_Flux_Divergence.mat Div_F