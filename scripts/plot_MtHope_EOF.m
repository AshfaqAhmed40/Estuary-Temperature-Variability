clear all; close all; clc;
tic

%loading file
HOME = '/Users/aahmed78/Desktop/Journal of Climate/v3/';
cd(strcat(HOME,'data'))
load MtHopeTEMPv3.mat

%% Mask the extreme values
MtHopeTEMPv3 = filloutliers(MtHopeTEMPv3, 'linear',3);


%% 1 Call the .nc file
DateCol = table2cell(DateStamp(:,3));
L7L8Dates = find(~contains(DateCol,'landsat_5')); %kicks out the L5 scenes
SST = MtHopeTEMPv3(:,:,L7L8Dates);
LAT = LAT2; LON = LON2;
clear D_SST LAT1 LON1 MtHopeTEMPv3

%% 2 Making 3D varibales into 2D
sstr = reshape(SST,length(SST(:,1,1))*length(SST(1,:,1)),length(SST(1,1,:)))';
latr = reshape(LAT,1,length(LAT(:,1))*length(LAT(1,:)));
lonr = reshape(LON,1,length(LON(:,1))*length(LON(1,:)));
sstr = [latr;lonr;sstr]; 

%% 3. Remove nan data (actually, 100% NaN columns)
sstr(:,sum(isnan(sstr(3:end,:)),1)==length(sstr(3:end,1)))=[];

%% 4. Take out LAT LON
coords = sstr(1:2,:);
sstr(1:2,:)   =[];

%% 5. Fill in with the nearest MtHopeTEMPv3oral data 
sstr = fillmissing(sstr,'linear',1,'EndValues','near');
SST = sstr;
%SST = rmmissing(SST,2);

%% 6. Normalize the MtHopeTEMPv3 data
datms = SST./nanstd(SST(:));

%% 7. Singular Value Decomposition
[U,S,V] = svds([datms],5);

%% 8. Calculate EEOFs
eeof1s = V(1:length(datms(1,:)),1);
eeof2s = V(1:length(datms(1,:)),2);
eeof3s = V(1:length(datms(1,:)),3);

%% 9. Reshape EEOFs
finaleeof1s = nan(size(LAT,1),size(LAT,2));
finaleeof2s = nan(size(LAT,1),size(LAT,2));
finaleeof3s = nan(size(LAT,1),size(LAT,2));

for ff = 1:length(eeof1s(:,1))
    finaleeof1s(coords(1,ff)==LAT(:,1),coords(2,ff)==LON(1,:)) = eeof1s(ff,1);
    finaleeof2s(coords(1,ff)==LAT(:,1),coords(2,ff)==LON(1,:)) = eeof2s(ff,1);
    finaleeof3s(coords(1,ff)==LAT(:,1),coords(2,ff)==LON(1,:)) = eeof3s(ff,1); 
end

%% 10. Saving the variables
U1 = U(:,1); U2 = U(:,2); U3 = U(:,3);

%% 11. Prepare the color map
clr = flipud(brewermap(15,'PrGn'));
clri= interp1(1:1:15,clr,1:0.25:15,'linear');
clr1= brewermap(25,'BrBg');
clri1=interp1(1:1:25,clr1,1:0.25:25,'linear');
clri1 = flip(clri1);
ColorMap = 'eclipse';
%% Plot all three EEOFs
figure(1),
% Landmask
landMask = isnan(flip(finaleeof1s));
contourf(gca, landMask, 5, 'edgecolor', 'none', 'FaceColor', ...
    [1 1 1]); hold on;
C = contourc(double(landMask), [0.5 0.5]);
while ~isempty(C)
    len = C(2, 1);
    plot(C(1, 2:1+len), C(2, 2:1+len), 'k', 'LineWidth', 3);
    C(:, 1:len+1) = []; hold on;
end
    
%[~, hContour]=contourf(LON,LAT,flip(finaleeof1s).*U1(522,1),50,'edgecolor','none');
pcolor(flip(finaleeof1s).*U1(1,1));
set(gca,'Color',[0.5 0.5 0.5]);
shading interp;
colormap(gca, flip(slanCM(ColorMap)));
caxis([-1e-5 1e-5]); colorbar
(diag(S(1,1)))^2/(sum(diag(S)))^2
hold on; box on; 
set(gca, 'GridLineStyle', '-', 'MinorGridLineStyle', ':', 'LineWidth', 3);
set(gca, 'FontSize', 30, 'FontWeight', 'bold');
set(gca, 'Layer', 'top');
set(gca, 'YTickLabel',[]);set(gca, 'XTickLabel',[]);
set(gcf, 'Position', [-1753,625,465,583]);

c = colorbar;
c.FontSize = 20;
c.FontWeight = 'bold'; 



%% Plot the EOF2
figure(2), clf;
% t = tiledlayout(1,2);
% t.TileSpacing = 'tight'; t.Padding = 'loose'
% nexttile

% Landmask
landMask = isnan(flip(finaleeof2s));
contourf(gca, landMask, 5, 'edgecolor', 'none', 'FaceColor', ...
    [1 1 1]); hold on;
C = contourc(double(landMask), [0.5 0.5]);
while ~isempty(C)
    len = C(2, 1);
    plot(C(1, 2:1+len), C(2, 2:1+len), 'k', 'LineWidth', 3);
    C(:, 1:len+1) = []; hold on;
end

[~, hContour]=contourf(flip(finaleeof2s).*U2(89,1),10,'linewidth',1);
% pcolor(flip(finaleeof2s).*U2(18,1));
set(gca,'Color',[0.5 0.5 0.5]);
shading interp
caxis([-1e-5 1e-5]);
(diag(S(2,2))+diag(S(1,1)))^2/(sum(diag(S)))^2
colormap(gca, flip(slanCM(ColorMap)));
hold on; box on; 
set(gca, 'GridLineStyle', '-', 'MinorGridLineStyle', ':', 'LineWidth', 3);
set(gca, 'FontSize', 20, 'FontWeight', 'bold');
set(gca, 'Layer', 'top');
set(gca, 'YTickLabel',[]);set(gca, 'XTickLabel',[]);
set(gcf, 'Position', [-1753,625,465,583]);

c = colorbar;
c.FontSize = 20;
c.FontWeight = 'bold'; 
        
%% Plot the EOF3
nexttile
% Landmask
landMask = isnan(flip(finaleeof2s));
contourf(gca, landMask, 5, 'edgecolor', 'none', 'FaceColor', ...
    [1 1 1]); hold on;
C = contourc(double(landMask), [0.5 0.5]);
while ~isempty(C)
    len = C(2, 1);
    plot(C(1, 2:1+len), C(2, 2:1+len), 'k', 'LineWidth', 3);
    C(:, 1:len+1) = []; hold on;
end

[~, hContour]=contourf(flip(finaleeof3s).*U3(6,1),8,'linewidth',1);
% pcolor(flip(finaleeof2s).*U2(18,1));
set(gca,'Color',[0.5 0.5 0.5]);
shading interp
caxis([-1e-5 1e-5]);
(diag(S(2,2))+diag(S(1,1)))^2/(sum(diag(S)))^2
colormap(gca, flip(slanCM(ColorMap)));
hold on; box on; 
set(gca, 'GridLineStyle', '-', 'MinorGridLineStyle', ':', 'LineWidth', 3);
set(gca, 'FontSize', 20, 'FontWeight', 'bold');
set(gca, 'Layer', 'top');
set(gca, 'YTickLabel',[]);set(gca, 'XTickLabel',[]);

c = colorbar;
c.FontSize = 16;
c.FontWeight = 'bold'; 
c.Layout.Tile = 'east';
set(gcf, 'Position', [-1295,622,817,582]);
%% Test for nice picture
figure(100),
clf;
t = tiledlayout(6,5);
t.TileSpacing = 'compact';
for i = 61:90
nexttile
[~, hContour]=contourf(flip(finaleeof2s).*U2(1,1),15,'linewidth',1);
shading interp; colormap(gca,clri1);
caxis([-1e-5 1e-5]);
title (sprintf('%d',i));
set(gca, 'YTickLabel',[]); set(gca, 'XTickLabel',[]);
end

c = colorbar;
c.FontSize = 6;
c.FontWeight = 'bold'; c.Label.String = 'Loadings';
c.Layout.Tile = 'east';
set(gcf, 'Position', [-2135,61,914,1276]);

%% 13. Plot EEOFs
TT = array2timetable(DateStamp.date(L7L8Dates),'RowTimes',DateStamp.date(L7L8Dates));
% this is to plot dates in the X-axis of the EEOFs
figure(3), clf;
t = tiledlayout(2,1);
t.TileSpacing = 'compact';
t.Padding = 'compact';

nexttile
plot(TT.Var1,U1,'color','#0000FF','markersize',1,'linewidth',3.5); hold on;
set(gca, 'XTickLabel');ylim([-0.2 0.2]);
hold on; box on; 
set(gca, 'GridLineStyle', '-', 'MinorGridLineStyle', ':', 'LineWidth', 1.5);
set(gca, 'FontSize', 16, 'FontWeight', 'bold'); ylabel('Normalized Unit');
set(gca, 'Layer', 'top'); 
xlabel('Year');


plot(TT.Var1,U2,'color','#A2142F','markersize',1,'linewidth',2); hold on;
set(gca, 'XTickLabel');ylim([-0.35 0.35]);
hold on; box on; 
set(gca, 'GridLineStyle', '-', 'MinorGridLineStyle', ':', 'LineWidth', 3);
set(gca, 'FontSize', 15, 'FontWeight', 'bold'); ylabel('Normalized Unit');
set(gca, 'Layer', 'top'); 
legend('EOF1','EOF2','location','northwest','fontsize',16);
xlabel('Year');
set(gcf, 'Position', [2664,205,934,450]);
grid on


% 14. Plotting the frequency spectra

yg1 = U1';yg2 = U2';
obsv = DateStamp.date(L7L8Dates);
[pxx1,f] = plomb(yg1,obsv,[],10,'power');
[pxx2,f] = plomb(yg2,obsv,[],10,'power');
f = f*86400*365;

nexttile
loglog(f,pxx1,'color','#0000FF','linewidth',2.5); hold on
loglog(f,pxx2,'color','#A2142F','linewidth',2.5); hold on

xlabel('Frequency (Year^{-1})');
xlim([10e-2 10]);
ylim([10e-11 1]); 
set(gca, 'GridLineStyle', '-', 'MinorGridLineStyle', ':', 'LineWidth', 3);
set(gca, 'FontSize', 15, 'FontWeight', 'bold');
set(gca, 'Layer', 'top'); ylabel('Power Spectra');
legend('EOF1','EOF2','location','northwest','fontsize',16);
grid minor
toc