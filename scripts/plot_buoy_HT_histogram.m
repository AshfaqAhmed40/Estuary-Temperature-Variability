clear all; close all; clc;
% HT calculation (with bootstrap) for buoy 11 or 13 location
% Elapsed time is 288.714588 seconds.
tic
%% call everyone
HOME = '/Users/aahmed78/Desktop/Journal of Climate/v3/';
cd(strcat(HOME,'data/'));
load Bouy_Locations_HT.mat


% load B11_HT.mat % Buoy 11
load B13_HT.mat % Buoy 13
% gives Landsat observation time+tide height
% gives Buoy observation time+tide height+temps (both)
% gives Landsat observation temp with seasons+deseasoned

T = rmmissing(T); % ignoring tthe NaN values
%% Prepare Landsat Time, Tide Height, Temps
% for only bouy location Landsat, combine them all!
% Landsat_HT = addvars(Landsat_Time,L_Bid{1,1},LD_Bid{1,1}); % Buoy 11
Landsat_HT = addvars(Landsat_Time,L_Bid{1,2},LD_Bid{1,2}); % Buoy 13

%% Histogram calculation
Mean_Landsat = []; Mean_Buoy = []; Std_Landsat = []; Std_Buoy = []; 

% ============================= Seasonal
% Buoy H(t)*T(t)
% HT_Buoy = Buoy H(t)*T(t)
HT_Buoy = (T.H./nanstd(T.H).*(T.Temp./nanstd(T.Temp)));

% Landsat H(t)*T(t)
% HT_Landsat = Landsat H(t)*T(t)
HT_Landsat = (Landsat_HT.HeightSeries./nanstd(Landsat_HT.HeightSeries)...
    .*(Landsat_HT.Var3./nanstd(Landsat_HT.Var3)));

% ============================= Deseasonalized

% HTD_Buoy = Buoy H(t)*T_d(t)
HTD_Buoy = (T.H./nanstd(T.H).*(T.D_Temp./nanstd(T.D_Temp)));

% HTD_Landsat = Landsat H(t)*T_d(t)
HTD_Landsat = (Landsat_HT.HeightSeries./nanstd(Landsat_HT.HeightSeries)...
    .*(Landsat_HT.Var4./nanstd(Landsat_HT.Var4)));

%% Bootstrap calculation
%[bootstat,bootsam] = bootstrp(1000,@corr,lsat,gpa);
Boot_Landsat{1} = bootstrp(size(HT_Landsat,1),@mean,HT_Landsat);
Boot_Landsat{2} = bootstrp(size(HT_Landsat,1),@mean,HTD_Landsat);

Boot_Buoy{1} = bootstrp(size(T,1),@mean,HT_Buoy);
Boot_Buoy{2} = bootstrp(size(T,1),@mean,HTD_Buoy);


%% Histogram plot
% this will plot the first two plot (H*T for season+deseason)
% this is not bootstrapped
figure(1),
clf; clc;
t = tiledlayout(2,2,'TileSpacing','Compact');
nexttile;
h11 = histfit(HT_Buoy,500,'kernel'); hold on;
set(h11(1),'facecolor',"#4DBEEE"); set(h11(2),'color',"#A2142F");
Mean_Buoy{1} = mean(HT_Buoy);
Std_Buoy{1} = std(HT_Buoy);


h12 = histfit(HT_Landsat);
set(h12(1),'facecolor',"#EDB120"); set(h12(2),'color','k')
Mean_Landsat{1} = mean(HT_Landsat);
Std_Landsat{1} = std(HT_Landsat);
hold on;
xlim([-20 20]);
title('\textbf{$\frac{{\mathbf{H(t) \cdot T(t)}}}{\mathbf{\sigma_H \cdot \sigma_T}}$}', 'interpreter', 'latex', 'FontSize', 35);
legend([h11(1),h12(1)],'Buoy','Landsat','location','northwest');
set(gca, 'GridLineStyle', ':', 'MinorGridLineStyle', ':', 'LineWidth', 2);
set(gca, 'FontSize', 15, 'FontWeight', 'bold');
set(gca, 'Layer', 'top')


nexttile
h21 = histfit(HTD_Buoy,500); hold on;
set(h21(1),'facecolor',"#4DBEEE"); set(h21(2),'color',"#A2142F");
Mean_Buoy{2} = mean(HTD_Buoy)
Std_Buoy{2} = std(HTD_Buoy)

h22 = histfit(HTD_Landsat);
set(h22(1),'facecolor',"#EDB120"); set(h22(2),'color','k')
Mean_Landsat{2} = mean(HTD_Landsat)
Std_Landsat{2} = std(HTD_Landsat)
hold on
xlim([-6 6]);

title('\textbf{$\frac{{\mathbf{H(t) \cdot T(t)}}}{\mathbf{\sigma_H \cdot \sigma_T}}$}', 'interpreter', 'latex', 'FontSize', 25);
legend([h21(1),h22(1)],'Buoy','Landsat','location','northwest');
set(gca, 'GridLineStyle', ':', 'MinorGridLineStyle', ':', 'LineWidth', 2);
set(gca, 'FontSize', 15, 'FontWeight', 'bold');
set(gca, 'Layer', 'top')

% This is Bootstrapped plot
nexttile;
h31 = histfit(Boot_Landsat{1}); hold on;
set(h31(1),'facecolor',"#EDB120"); set(h31(2),'color','k')
h32 = histfit(Boot_Buoy{1},1500); hold on;
set(h32(1),'facecolor',"#4DBEEE"); set(h32(2),'color',"#A2142F");
xlim([-0.4 0.4]); ylim([0 250])
title(['\bf Bootstrapped ', '$\frac{{H(t) \cdot T(t)}}{\sigma_H \cdot \sigma_T}$'], 'interpreter', 'latex', 'FontSize', 25);
legend([h31(1),h32(1)],'Landsat','Buoy','location','northwest');
set(gca, 'GridLineStyle', ':', 'MinorGridLineStyle', ':', 'LineWidth', 2);
set(gca, 'FontSize', 15, 'FontWeight', 'bold');
set(gca, 'Layer', 'top')

nexttile
h41 = histfit(Boot_Landsat{2}); hold on;
set(h41(1),'facecolor',"#EDB120"); set(h41(2),'color','k')
h42 = histfit(Boot_Buoy{2},1500); hold on;
set(h42(1),'facecolor',"#4DBEEE"); set(h42(2),'color',"#A2142F");
xlim([-0.4 0.4]); ylim([0 250])
set(gca, 'GridLineStyle', ':', 'MinorGridLineStyle', ':', 'LineWidth', 2);
set(gca, 'Layer', 'top');
set(gcf, 'Position', [4057,605,714,569]);
title(['\bf Bootstrapped ', '$\frac{{H(t) \cdot T(t)}}{\sigma_H \cdot \sigma_T}$'], 'interpreter', 'latex', 'FontSize', 25);
set(gca, 'FontSize', 15, 'FontWeight', 'bold');
legend([h41(1),h42(1)],'Landsat','Buoy','location','northwest');


clearvars -except bid7_L bid7_LD HT_Buoy HT_Landsat Landsat_HT...
    T Mean_Buoy Mean_Landsat HTD_Landsat HTD_Buoy Boot_Landsat Boot_Buoy
%% Table
clc
Mean = []; Std = []; Skewness = []; Kurtosis = [];
Seasonal_Property = {'Landsat';'Buoy';'Bootstrapped Landsat';'Bootstrapped Buoy'};
Mean{1} = [mean(HT_Landsat);mean(HT_Buoy);mean(Boot_Landsat{1});mean(Boot_Buoy{1})];
Std{1} =  [std(HT_Landsat);std(HT_Buoy);std(Boot_Landsat{1});std(Boot_Buoy{1})];
Skewness{1} = [skewness(HT_Landsat);skewness(HT_Buoy);skewness(Boot_Landsat{1});skewness(Boot_Buoy{1})];
Kurtosis{1} = [kurtosis(HT_Landsat);kurtosis(HT_Buoy);kurtosis(Boot_Landsat{1});kurtosis(Boot_Buoy{1})];

T1 = table(Seasonal_Property,Mean{1},Std{1},Skewness{1},Kurtosis{1});
T1.Properties.VariableNames{2} = 'Mean';
T1.Properties.VariableNames{3} = 'Std';
T1.Properties.VariableNames{4} = 'Skewness';
T1.Properties.VariableNames{5} = 'Kurtosis'


Deseasoned_Property = {'Landsat';'Buoy';'Bootstrapped Landsat';'Bootstrapped Buoy'};
Mean{2} = [mean(HTD_Landsat);mean(HTD_Buoy);mean(Boot_Landsat{2});mean(Boot_Buoy{2})];
Std{2} =  [std(HTD_Landsat);std(HTD_Buoy);std(Boot_Landsat{2});std(Boot_Buoy{2})];
Skewness{2} = [skewness(HTD_Landsat);skewness(HTD_Buoy);skewness(Boot_Landsat{2});skewness(Boot_Buoy{2})];
Kurtosis{2} = [kurtosis(HTD_Landsat);kurtosis(HTD_Buoy);kurtosis(Boot_Landsat{2});kurtosis(Boot_Buoy{2})];

T2 = table(Deseasoned_Property,Mean{2},Std{2},Skewness{2},Kurtosis{2});

T2.Properties.VariableNames{2} = 'Mean';
T2.Properties.VariableNames{3} = 'Std';
T2.Properties.VariableNames{4} = 'Skewness';
T2.Properties.VariableNames{5} = 'Kurtosis'



toc
