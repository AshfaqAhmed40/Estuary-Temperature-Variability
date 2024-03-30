clear all; close all; clc;

% This code plots the HT diagram for the buoy we are selecting.
% It first calls the Landsat SST dataset and collects the Landsat temperature
% series at the buoy location. 

% For buoy 11: x = 41.6799°N; y = -71.2156°E;
% For buoy 13: x = 41.4922°N; y = -71.4189°E;

%% Load the SST (both season and deseasoned version)
HOME = '/Users/aahmed78/Desktop/Journal of Climate/v3/';
cd(strcat(HOME,'data/'));
load TEMPv3.mat
load Desdet_Fourier_Bay_v3.mat

%% SST at the buoy location
B11 = [(1130-909),16]; % For buoy 11
B13 = [(1130-188),90]; % For buoy 13 
L_Bid{1} = squeeze(TEMPv3(B11(1),B11(2),:)); 
L_Bid{2} = squeeze(TEMPv3(B13(1),B13(2),:));
% Landsat temperature at buoy location
% L_Bid{1} contains buoy 11 information and L_Bid{2} contains buoy 13
LD_Bid{1} = squeeze(Desdet_Fourier_Bay_v3(B11(1),B11(2),:));
LD_Bid{2} = squeeze(Desdet_Fourier_Bay_v3(B13(1),B13(2),:));
% Deseasonalized detrended Landsat temperature at buoy location

%% Plot buoy temp from Landsat (to check everything is sane)
close all
figure(1),
plot(L_Bid{1}); hold on; ylim([-30 30]);
plot(LD_Bid{1},'r-'); hold on; ylim([-30 30]);
figure(2), %location test
% Note that, when I am plotting, the row and colum indices are  shifted
pcolor((TEMPv3(:,:,1))); shading flat; hold on
plot(16, (1130-909),'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k'); hold on
plot(90,(1130-188), 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k'); hold on
%% Load the tide height and temp data from the buoy 
load B13_HT.mat
% this file contains:
% Landsat_Time contains Landsat datetimes and the instantaneous SSH at buoy location
% T contains buoy datetimes, buoy temp, instantaneous SSH at buoy location,
% and deseasonalized in-situ buoy temperature

%% HT Diagram preparation
ST_L = (L_Bid{1}-mean(L_Bid{1}))./nanstd(L_Bid{1}); 
% seasonal (S) temperature (T) from Landsat (L) @ buoy
DT_L = (LD_Bid{1}-mean(LD_Bid{1}))./nanstd(LD_Bid{1}); 
% deseasonal (D) temperature (T) from Landsat (L) @ buoy

ST_B = (T.Temp-nanmean(T.Temp))./nanstd(T.Temp); 
% seasonal (S) temperature (T) from buoy
DT_B = (T.D_Temp-nanmean(T.D_Temp))./nanstd(T.D_Temp); 
% deseasonal (D) temperature (T) from buoy

H_L = (Landsat_Time.HeightSeries-mean(Landsat_Time.HeightSeries))...
    ./nanstd(Landsat_Time.HeightSeries); 
% height (H) of water when Landsat took pictures
H_B = (T.H-nanmean(T.H))./nanstd(T.H); 
% height (H) of water when buoy recorded temmperature

SHT_L = ST_L.*H_L;
% seasonal HT of Landsat
DHT_L = DT_L.*H_L;
% deseasonal HT of Landsat

SHT_B = ST_B.*H_B;
% seasonal HT of buoy
DHT_B = DT_B.*H_B;
% deseasonal HT of buoy


figure(1),
subplot(4,1,1)
plot(Landsat_Time.TimeSeries,ST_L, 'b-', 'markersize',3); hold on;
ylabel('HT from Landsat record');
legend('With season'); ylim([-5 5]);

subplot(4,1,2)
plot(Landsat_Time.TimeSeries,DT_L, 'k-', 'markersize',3); hold off;
ylabel('HT from Landsat record');
legend('Withot seasons'); ylim([-5 5]);

subplot(4,1,3)
plot(T.Time, SHT_B, 'b-', 'markersize',3); hold on;
ylabel('HT from buoy record');
legend('With season'); ylim([-5 5]);

subplot(4,1,4)
plot(T.Time, DHT_B, 'k-', 'markersize',3); hold off;
ylabel('HT from buoy record');
legend('Withot seasons'); ylim([-5 5]);

clearvars -except HOME Landsat_Time T ST_L DT_L ST_B DT_B H_B H_L SHT_L ...
    DHT_L SHT_B DHT_B L_Bid LD_Bid TEMPv3 B11 B13 Desdet_Fourier_Bay_v3

%% Plot HT diagram
close all
figure(1),
plot(H_L, ST_L,'color','#D95319','marker','.','linestyle','none');hold on
plot(nanmean(H_L), nanmean(ST_L),'pk','markersize',25, 'linewidth',2); hold on
set(gca,'LineWidth', 3); 
set(gca,'FontSize',40,'FontWeight','bold');
ylabel('T^*', 'FontSize', 40);
xlabel('H^*', 'FontSize', 40);
axis([-4 4 -4 4]);grid on
plot([0 0], [-5 5], 'k-'); plot([-5 5], [0 0], 'k-'); 
set(gcf, 'Position', [-1497,598,607,604]); 


figure(2),
plot(H_L, DT_L,'.');hold on
plot(nanmean(H_L), nanmean(DT_L),'pk','markersize',25, 'linewidth',2); hold on
set(gca,'LineWidth', 3); 
set(gca,'FontSize',40,'FontWeight','bold');
ylabel('T^*', 'FontSize', 40);
xlabel('H^*', 'FontSize', 40);
axis([-4 4 -4 4]);grid on
plot([0 0], [-5 5], 'k-'); plot([-5 5], [0 0], 'k-');
set(gcf, 'Position', [-1497,598,607,604]); 

figure(3),
plot(H_B,ST_B,'color','#D95319','marker','.','linestyle','none');hold on
plot(nanmean(H_B), nanmean(ST_B),'pk','markersize',25, 'linewidth',2); hold on
set(gca,'LineWidth', 3); 
set(gca,'FontSize',40,'FontWeight','bold');
ylabel('T^*', 'FontSize', 40);
xlabel('H^*', 'FontSize', 40);
axis([-4 4 -4 4]);grid on
plot([0 0], [-5 5], 'k-'); plot([-5 5], [0 0], 'k-'); 
set(gcf, 'Position', [-1497,598,607,604]); 

figure(4),
plot(H_B,DT_B,'.'); hold on;
plot(nanmean(H_B), nanmean(DT_B),'pk','markersize',25, 'linewidth',2); hold on
plot([0 0], [-5 5], 'k-'); plot([-5 5], [0 0], 'k-'); 
axis equal
set(gca,'LineWidth', 3); 
set(gca,'FontSize',40,'FontWeight','bold');
ylabel('T^*', 'FontSize', 40);
xlabel('H^*', 'FontSize', 40);
axis([-4 4 -4 4]); grid on
set(gcf, 'Position', [-1497,598,607,604]); 
