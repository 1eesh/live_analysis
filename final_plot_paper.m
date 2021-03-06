%% PLOT FOR WATER INJECTION
clear all;



%interpolation for time after injection and then interpolation for 10
%seconds before injection and the concatenate the two arrays

load('water_image21_histogram_thresholds_plotting_variables.mat','allcells_no','time_number');
allcells_no_21=allcells_no;
time_number_21=time_number;
allcells_no_21=interp1(1:7.8:14*7.8,mean(allcells_no_21(:,29:42)),1:1:120);

load('water_image5_histogram_thresholds_plotting_variables.mat','allcells_no','time_number');
allcells_no_5=allcells_no;
time_number_5=time_number;
allcells_no_5=interp1(1:6.9:17*6.9,mean(allcells_no_5(:,21:37)),1:1:120);


% ACTUAL PLOT
allcells_no=[allcells_no_21 ; allcells_no_5 ];

shadedErrorBar(1:1:120,nanmean(allcells_no),nanstd(allcells_no));

hx_1 = graph2d.constantline(8, 'Color',[1 0 0]);
changedependvar(hx_1,'x');
xlim([0 100]);
ylim([0 6]);
xlabel('Time(seconds)');
ylabel('Number of Discrete Structures');
title('Water Injections');





%% PLOT FOR ROK INJECTIONS
clear all;

load('roki_image1_histogram_thresholds_plotting_variables.mat','allcells_no','time_number');
allcells_no_1=allcells_no;
time_number_1=time_number;
allcells_no_1_final=interp1(1:8.4:(time_number_1-6)*8.4,mean(allcells_no_1(:,7:time_number_1)),1:1:240);

%scatter(7:1:time_number_1,mean(allcells_no_1(:,7:size(allcells_no_1,2))))
%trying a filter for inactive cells



%



load('roki_image5_histogram_thresholds_plotting_variables.mat','allcells_no','time_number');
allcells_no_5=allcells_no;
time_number_5=time_number;
allcells_no_5_final=interp1(1:8.3:(60-31)*8.3,mean(allcells_no_5(:,32:60)),1:1:240);

scatter(1:1:time_number_5,mean(allcells_no_5))
xlabel('Time(seconds)');
ylabel('Number of Discrete Structures');
title('Rok Inhibitor Injections(Individual Embryo)');
hx_1 = graph2d.constantline(30, 'Color',[1 0 0]);
changedependvar(hx_1,'x');




load('roki_image7_histogram_thresholds_plotting_variables.mat','allcells_no','time_number');
allcells_no_7=allcells_no;
time_number_7=time_number;
allcells_no_7_final=interp1(1:24.3:11*24.3,mean(allcells_no_7(:,4:14)),1:1:240);

%scatter(3:1:time_number_7,mean(allcells_no_7(:,3:size(allcells_no_7,2))))



% ACTUAL PLOT
allcells_no=[allcells_no_5_final ; allcells_no_7_final ; allcells_no_1_final];




shadedErrorBar(1:1:240,nanmean(allcells_no),nanstd(allcells_no));
hx_1 = graph2d.constantline(1, 'Color',[1 0 0]);
changedependvar(hx_1,'x');
xlim([0 200]);
ylim([0 6]);
xlabel('Time(seconds)');
ylabel('Number of Discrete Structures');
title('Rok Inhibitor Injections');
