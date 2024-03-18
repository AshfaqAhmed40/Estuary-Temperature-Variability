clear all; close all; clc;

%% Call
HOME = '/Users/aahmed78/Desktop/Journal of Climate/v3/';
cd(strcat(HOME,'data'));

load TEMPv3.mat
load BayTEMPmean_v3.mat


%% Assign the Deseaonalized 3D martrix
SST_Des = YearlyMeanDes;

%% Bootstrap to calculate spatial uncertainty
[rows, columns, years] = size(SST_Des);
n = 100;

bootstrapMean = zeros(1, years);
bootstrapStd = zeros(1, years);

% Bootstrap for each year
for Y = 1:years
    % Resample the data for the current year with replacement
    validIndices = find(~isnan(SST_Des(:,:,Y)));
    numValidIndices = numel(validIndices);
    
    bootstrapIndices = validIndices(randi(numValidIndices, [rows, columns, n]));
    bootstrapSamples = SST_Des(:,:,Y);
    bootstrapSamples = bootstrapSamples(bootstrapIndices);
    
    % Calculate mean and standard deviation for each bootstrap sample
    bootstrapMean(Y) = mean(bootstrapSamples(:));
    bootstrapStd(Y) = std(bootstrapSamples(:));
end

% Store bootstrap results in a struct
bootstrapSSTStats.mean = bootstrapMean;
bootstrapSSTStats.stdDev = bootstrapStd;
Mean = bootstrapMean;
x = 1984:2022;
sd = bootstrapStd;
T = 1:numel(Mean);

% calculate the trendline
% Calculate linear regression coefficients (slope and intercept)
coeffs = polyfit(1:numel(Mean), Mean, 1);
slope = coeffs(1);
intercept = coeffs(2);

% Calculate the trend line
trendLine = slope * T + intercept;

%% Calculate temporal uncertainty
datestring=string(table2cell(DateStamp(:,1)));
datevector=datevec(datestring);
datevector(:,4)=10;
datet=datetime(datevector);
y0=year(datet(1))+(days(datet(1)-datetime([1984,1,1,10,0,0])))/366;  % 1984 is a leap year
dur=hours(datet-datet(1))/24/365.2425;  % This is fixed duration years' duration since y0
t=y0+dur;
MtHopeTEMPm=nan*zeros(size(TEMPv3(:,:,1:39)));
Idx = cell(1, 2022 - 1983);

for yy=1984:2022
   ndx=find(yy==year(datet));
   tm(yy-1983)=mean(t(ndx));
   MtHopeTEMPm(:,:,yy-1983)=mean(TEMPv3(:,:,ndx),3);
   sd_T(yy-1983) = mean(nanstd(TEMPv3(:,:,yy-1983)));
   Idx{yy - 1983} = ndx;
end

% calculate 
for i = 1:39
    std_T(i) = sd_T(i)/size(Idx{i},1);
end


%% Plot the spatial temporal uncertainty
figure(1), clf;

patch([x fliplr(x)], [Mean-(sd./sqrt(2))  fliplr(Mean+(sd./sqrt(2)))], [0.8500 0.4250 0.0980]);hold on;
patch([x fliplr(x)], [Mean-std_T  fliplr(Mean+std_T)], [0.9290 0.6940 0.1250]);hold on;
plot(x, Mean,'ko-','linewidth',2,'markersize',10); hold on;
plot(x, trendLine, 'k--', 'LineWidth', 5); hold on;
title('Mt. Hope Bay Yearly Mean Temperature Trend');
grid minor;  box on;
set(gca, 'XTickLabel'); set(gca, 'YTickLabel');
set(gca, 'GridLineStyle', '-', 'MinorGridLineStyle', ':', 'LineWidth', 3);
set(gca, 'FontSize', 25, 'FontWeight', 'bold');
set(gca, 'Layer', 'top');
xlim([1984 2022]); ylim([5 18]);
xlabel('Year'); ylabel('Temperature (°C)'); 
set(gcf, 'Position', [-2363,316,1974,1006]);
legend('Spatial Sampling Uncertainty', 'Temporal Sampling Uncertainty',...
    'Yealy Mean Temperature', 'Trendline','Location','southeast','fontsize',35)


%% Result
clc;
% Display spatial bootstrapped uncertainty results
disp('spatial bootstrapped uncertainty Results:');
for Y = 1:years
    fprintf('Year %d - Mean: %.2f, Standard Deviation: %.2f\n', Y, Mean(Y), sd(Y));
end
toc

%% Save variables for later plot
save('BayAnnualTrend.mat','Mean','sd','sd_T','std_T','trendLine','x','Y','years','coeffs');