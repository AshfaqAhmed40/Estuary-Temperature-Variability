close all; clc; clear all;


%% Biases
% Define values of m for each satellite
m_L5 = -0.0167;
m_L7 = -0.1068; 
m_L8 = -0.13038;

% Define values of n for each satellite
n_L5 = 1.188;
n_L7 = 1.6711; 
n_L8 = 2.2719;

%% Load data
HOME = '/Users/aahmed78/Desktop/Journal of Climate/v3/';
cd(strcat('/Users/aahmed78/Desktop/Journal of Climate/Infilled Data/Bay'));
load Infilled_Bay.mat
load DateStamp.mat
cd(strcat(HOME))

%% Find indices for each satellites
DateCol = table2cell(DateStamp(:,3));
L5_idx = find(contains(DateCol,'landsat_5'));
L7_idx = find(contains(DateCol,'landsat_7'));
L8_idx = find(contains(DateCol,'landsat_8'));

%% Apply bias correction
TEMPv1 = zeros(size(TEMP)); % not bias corrected
TEMPv2 = TEMP;              % bias corrected by Dan
TEMPv3 = zeros(size(TEMP)); % bias corrected by Ashfaq 

% first, remove Dan's biases
TEMPv1(:,:,L5_idx) = TEMPv2(:,:,L5_idx) + (-0.45);
TEMPv1(:,:,L7_idx) = TEMPv2(:,:,L7_idx) + (-1.094);
TEMPv1(:,:,L8_idx) = TEMPv2(:,:,L8_idx) + (0.178);

% now, I apply my bias correction
TEMPv3(:,:,L5_idx) = TEMPv1(:,:,L5_idx) + (TEMPv1(:,:,L5_idx).*m_L5 + n_L5);
TEMPv3(:,:,L7_idx) = TEMPv1(:,:,L7_idx) + (TEMPv1(:,:,L7_idx).*m_L7 + n_L7);
TEMPv3(:,:,L8_idx) = TEMPv1(:,:,L8_idx) + (TEMPv1(:,:,L8_idx).*m_L8 + n_L8);

% reduce the size
TEMPv3 = round(TEMPv3, 2);
TEMPv3 = filloutliers(TEMPv3, 'linear',3);