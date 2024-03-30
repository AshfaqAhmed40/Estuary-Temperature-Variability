clear all; close all; clc;

%% Call
HOME = '/Users/aahmed78/Desktop/Journal of Climate/v3/';
cd(strcat(HOME,'data'));

%% Define colormap
CM = colormap(slanCM('RdYlBu'));
cmap = flip(CM);

%% NBay - Temporal
load BayAnnualTrend.mat
Mean1=Mean;sd1=sd;std_T1=std_T;trendLine1=trendLine;x1=x;Y1=Y;years1=years;
% Plot the spatial temporal uncertainty
figure(1), clf;

patch([x1 fliplr(x1)], [Mean1-sd1  fliplr(Mean1+sd1)], ...
    [0.55 0.55 0.55], 'facealpha', 0.35,'edgecolor', 'none');hold on;
patch([x1 fliplr(x1)], [Mean1-std_T1  fliplr(Mean1+std_T1)], ...
    [0.35 0.35 0.35],'edgecolor', 'none');hold on;
plot(x1, Mean1,'k-','linewidth',3,'markersize',15); hold on;
plot(x1, trendLine1, 'k--','LineWidth', 7); hold on;
grid minor;  box on;
set(gca, 'XTickLabel'); set(gca, 'YTickLabel');
set(gca, 'GridLineStyle', '-', 'MinorGridLineStyle', ':', 'LineWidth', 3);
set(gca, 'FontSize', 25, 'FontWeight', 'bold');
set(gca, 'Layer', 'top');
xlim([1984 2022]);
xlabel('Year'); ylabel('Temperature (°C)'); 
set(gcf, 'Position', [-2363,316,1974,1006]); 

%% MtHope Bay - Temporal
load MtHopeAnnualTrend.mat
% Plot the spatial temporal uncertainty
patch([x fliplr(x)], [Mean-sd  fliplr(Mean+sd)], ...
    [0.65 0 0], 'facealpha', 0.55,'edgecolor', 'none');hold on;
patch([x fliplr(x)], [Mean-std_T  fliplr(Mean+std_T)], ...
    [0.45 0 0],'edgecolor', 'none');hold on;
plot(x, Mean,'r-','linewidth',3,'markersize',15); hold on;
plot(x, trendLine, 'r--', 'LineWidth', 7); hold on;
title('Yearly mean temperature trend for the bays');
grid minor;  box on;
set(gca, 'XTickLabel'); set(gca, 'YTickLabel');
set(gca, 'GridLineStyle', '-', 'MinorGridLineStyle', ':', 'LineWidth', 3);
set(gca, 'FontSize', 35, 'FontWeight', 'bold');
set(gca, 'Layer', 'top');
xlim([1984 2022]); ylim([9 17]);
xlabel('Year'); ylabel('Temperature (°C)'); 
set(gcf, 'Position', [48,289,1974,1048]); 
legend('N. Bay: Spatial Sampling Uncertainty', 'N. Bay: Temporal Sampling Uncertainty',...
    'N. Bay: Yealy Mean Temperature', 'N. Bay: Trendline',...
    'Mt. Hope Bay: Spatial Sampling Uncertainty', 'Mt. Hope Bay: Temporal Sampling Uncertainty',...
    'Mt. Hope Bay: Yealy Mean Temperature', 'Mt. Hope Bay: Trendline','Location','southeast','fontsize',28)


%% NBay - Spatial
load BayTEMPmean_v3.mat
figure(2), clf;
pcolor(flip(TEMPv3trnd));  
shading interp;
caxis([0.008 0.07]); box on;
% Set colorbar with custom colormap
c = colorbar;
colormap(cmap); % Use custom colormap
c.FontSize = 25;
c.FontWeight = 'bold';
PLOT()

%% NBay - Spatial
load MtHopeTEMPmean_v3.mat
figure(3), clf;
contourf(flip(MtHopeTEMPv3trnd),20,'linewidth',0.5); % Adjust the levels as needed
shading interp;
caxis([0 0.05]); box on;
% Set colorbar with custom colormap
c = colorbar;
colormap(cmap); % Use custom colormap
c.FontSize = 25;
c.FontWeight = 'bold';
PLOT()


%% Function to plot
function PLOT()
    set(gca,'Color',[0.15 0.15 0.15])
    hold on; box on;
    set(gca, 'GridLineStyle', '-', 'MinorGridLineStyle', ':', 'LineWidth', 3);
    set(gca, 'FontSize', 15, 'FontWeight', 'bold');
    set(gca,'XTickLabel',[]);set(gca,'YTickLabel',[]);
    set(gca, 'Layer', 'top');
    set(gcf, 'Position', [-2156,295,824,1042]);
end
