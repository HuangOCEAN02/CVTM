clear;clc;close all
%%
ie = 817;     je = 619;
spongee = 0;spongew = 30;
spongen = 30;sponges = 30;
ie = ie - spongee - spongew;
je = je - sponges - spongen;
load('res_uso_level1_CV.mat')
Au = amph(:,3);
Pu = gphh(:,3);
clear lono lato
load('/res_vse_level1_CV.mat')
Av = amph(:,3);
Pv = gphh(:,3);
clear lono lato
load('res_eta_level1_CV.mat', 'lono')
load('res_eta_level1_CV.mat', 'lato')

LONLIMS = [min(lono) max(lono)];
LATLIMS = [min(lato) max(lato)];

LONLIMS = [-20.5 -16.5];
LATLIMS = [13 16];

LONLIMS = [-26.5 -20.5];
LATLIMS = [14 18];
%%
Au =  reshape(Au,[ie+1,je]);
Pu =  reshape(Pu,ie+1,je);
Av =  reshape(Av,ie,je+1);
Pv =  reshape(Pv,ie,je+1);
lon_grid = reshape(lono,[ie,je]);
lat_grid = reshape(lato,[ie,je]);
Auu(1:ie,:) = (Au(2:ie+1,:) + Au(1:ie,:))/2.0;
Puu(1:ie,:) = (Pu(2:ie+1,:) + Pu(1:ie,:))/2.0;
Avv(:,1:je) = (Av(:,2:je+1) + Av(:,1:je))/2.0;
Pvv(:,1:je) = (Pv(:,2:je+1) + Pv(:,1:je))/2.0;
%%
Auu(Auu==0)=nan;
Puu(Puu==0)=nan;
Avv(Avv==0)=nan;
Pvv(Pvv==0)=nan;
[SEMA,ECC,INC,PHA]=ap2ep(Auu, Puu, Avv, Pvv);


SEMA_grid = SEMA*100; %convert to cm/s
ECC_grid = ECC;
INC_grid = INC;
PHA_grid = PHA;
SEMI_grid = abs(ECC_grid).*SEMA_grid;


save M2_inc.mat INC_grid
