% This plots all high/low/ebb/flood tide scenes and calculates 
% if mean of any pixel is greater than the uncertainty
clear all; close all; clc;

%% Calling the data
HOME = '/Users/aahmed78/Desktop/Journal of Climate/v3/';
cd(strcat(HOME,'data'))
load TEMPv3.mat
load DATE_SECTIONS.mat
load Desdet_Month_Bay_v3.mat

%% Work with real temeprature!
SST = Desdet_Month_Bay_v3; % deseason by month
% SST = NMtHopeBayTEMPdetdes; % deseason by Fourier
LAT = LAT1; LON = LON1;

%% 1.1 Assigning the SST map based on their tidal features
% All temp are deseasonalized
% Serial: Low>Flood>High>Ebb
IDX = {idx_low,idx_flood,idx_high,idx_ebb};
% contains the indices of hjigh, low, ebb, and flood tides
Tide{1} = mean(SST(:,:,IDX{1}),3,'omitnan'); 
%mean deseasonalized high tide temp scenes
Tide{2} = mean(SST(:,:,IDX{2}),3,'omitnan'); 
%mean deseasonalized low tide temp scenes
Tide{3} = mean(SST(:,:,IDX{3}),3,'omitnan');
%mean deseasonalized ebb tide temp scenes
Tide{4} = mean(SST(:,:,IDX{4}),3,'omitnan'); 
%mean deseasonalized flood tide temp scenes


clearvars -except SST Tide LAT LON IDX

%% Preparing the color map
clr = flipud(brewermap(15,'RdYlBu'));
clri1= interp1(1:1:15,clr,1:0.15:15,'linear');
clr = flipud(brewermap(15,'RdPu'));
clri2= flip(interp1(1:1:15,clr,1:0.15:15,'linear'));
clr = flipud(brewermap(15,'Blues'));
clri3= (interp1(1:1:15,clr,1:0.15:15,'linear'));

%% Plot
close all;
% draft calculation for one case
% A = SST(:,:,IDX{1});
% mu = Tide{1};
% sigma = nanstd(A,[],3);
% idx = mu >= sigma/sqrt(268);
figure(1),
clf;

figure(1),
t = tiledlayout(2,2);
t.TileSpacing = 'tight';
t.Padding = 'compact';

for i = 1:4
    nexttile
    contourf(LON,LAT,flip(Tide{i}), 15, '.', 'linewidth', 1);
    pcolor(LON,LAT,flip(Tide{i}));
    set(gca,'Color',[0.15 0.15 0.15]);
    shading interp;
        colormap(gca,[clri1]);
        hold on; box on; caxis([-1 1]);
        set(gca, 'GridLineStyle', '-', 'MinorGridLineStyle', ':', 'LineWidth', 3);
        set(gca, 'FontSize', 12, 'FontWeight', 'bold');
        set(gca, 'Layer', 'top');
        set(gca, 'YTickLabel',[]);
        set(gca, 'XTickLabel',[]);
end
 

c = colorbar;
c.FontSize = 25;
c.FontWeight = 'bold'; 
c.Layout.Tile = 'east';
set(gcf, 'Position', [-2520,290,870,1047]);

%% B&W SNR
% figure(2),
% t = tiledlayout(2,4);
% t.TileSpacing = 'compact';
% t.Padding = 'compact';
% for i = 1:4    
% nexttile
% idx = (Tide{i}).^2 < (abs((nanstd(SST(:,:,IDX{i}),[],3))./sqrt(size(IDX{i},1)))).^2;
% h = pcolor(flip(idx));
% colormap(gca,[clri2]); caxis([0 1]);
% h.EdgeColor = 'none';
% set(gca, 'XTickLabel', []);set(gca, 'YTickLabel', []);
% end
%  
% 
% for i =1:4
% nexttile
% idx = (Tide{i}).^2 > (abs((nanstd(SST(:,:,IDX{i}),[],3))./sqrt(size(IDX{i},1)))).^2;
% h = pcolor(flip(idx));
% colormap(gca,[clri2]); caxis([0 1]);
% h.EdgeColor = 'none';
% set(gca, 'XTickLabel', []);set(gca, 'YTickLabel', []);
% end
% 
% c = colorbar;
% c.FontSize = 25;
% c.FontWeight = 'bold'; c.Label.String = 'Logical Operator';
% c.Layout.Tile = 'east';
% set(gcf, 'Position', [-2339,531,1307,806]);

%% Student's t-test
% % low tide
% % Assuming SST is your 3D matrix of size [1130, 800, 235]
% % and each page in the 3rd dimension represents a daily temperature map
% figure(3),
% clf;
% t = tiledlayout(2,2);
% t.TileSpacing = 'tight';
% t.Padding = 'compact';
% for i = 1:4
% nexttile
% % Step 1: Calculate mean and standard deviation across the 50 time steps
% mean_SST = Tide{i};
% std_SST = nanstd(SST(:,:,IDX{i}), 0, 3);
% % Step 2: Compute the standard error
% n = size(IDX{i},1); % Number of time steps, which is 50 in your case
% standard_error = std_SST / sqrt(n);
% % Step 3: Determine the critical t-value for a one-sided test at the 5% significance level
% % Degrees of freedom is number of observations minus one
% df = n - 1;
% critical_t_value = tinv(0.95, df);
% % Step 4: Calculate the significance threshold for mean SST
% significance_threshold = critical_t_value * standard_error;
% % This threshold represents the value above which the mean SST is considered
% % significantly different from zero with 95% confidence for a one-sided test
% pcolor(flip(significance_threshold)); 
% shading flat; shading interp; 
% colormap(gca, clri1); 
% set(gca,'Color',[0 0 0]);
%     caxis([0.3 0.6]);  % Include the log10(1e-6) value in the color axis
%     shading flat;
%     set(gca, 'GridLineStyle', '-', 'MinorGridLineStyle', ':', 'LineWidth', 3);
%     set(gca, 'FontSize', 12, 'FontWeight', 'bold');
%     set(gca, 'Layer', 'top');
%     set(gca, 'XTickLabel', []); set(gca, 'YTickLabel', []);
% end
% c = colorbar;
% c.FontSize = 25;
% c.FontWeight = 'bold';
% c.Layout.Tile = 'east';
% set(gcf, 'Position', [-2520,290,870,1047]);

%% Signal to Noise Ratio (SNR)
figure(4),
clf;
t = tiledlayout(2,2);
t.TileSpacing = 'tight';
t.Padding = 'compact';

% Define the brown color
brown = [255 255 0]/255;  % RGB for brown color

for i = 1:4
    nexttile
    SNR{i} = ((Tide{i}).^2).*(size(IDX{i},1))./(nanstd(SST(:,:,IDX{i}),[],3)).^2;
    SNR{i}(~isnan(SNR{i}) & SNR{i} < 1.645) = 1e-6;

    % Take the logarithm of SNR{i}, since all values are now >= 1e-6
    logSNR = 10.*log10(SNR{i});
    logSNR(isnan(SNR{i})) = NaN;  % Ensure NaNs remain as NaNs
    
    % Plot the data
    h = pcolor(flip(logSNR));
    set(gca,'Color',[0.15 0.15 0.15]);

    % Create a custom colormap with brown for the small positive value
    customColormap = [brown; clri2];  % Append brown at the beginning
    colormap(gca, customColormap); 

    caxis([1.645 10]);  % Include the log10(1e-6) value in the color axis
    shading interp;
    set(gca, 'GridLineStyle', '-', 'MinorGridLineStyle', ':', 'LineWidth', 3);
    set(gca, 'FontSize', 12, 'FontWeight', 'bold');
    set(gca, 'Layer', 'top');
    h.EdgeColor = 'none';
    set(gca, 'XTickLabel', []); set(gca, 'YTickLabel', []);
end

c = colorbar;
c.FontSize = 25;
c.FontWeight = 'bold';
c.Layout.Tile = 'east';
set(gcf, 'Position', [-2520,290,870,1047]);

