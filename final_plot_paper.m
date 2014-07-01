clear 

load('water_image21_histogram_thresholds_plotting_variables.mat','allcells_no','time_number');
allcells_no_21=allcells_no(:,1:40);
time_number_21=time_number;


load('water_image5_histogram_thresholds_plotting_variables.mat','allcells_no','time_number');
allcells_no_5=allcells_no;
time_number_5=time_number;



%% ACTUAL PLOT
allcells_no=[allcells_no_21 ; allcells_no_5 ];

scatter(1:7.8:time_number*7.8,mean(allcells_no_21))
scatter(1:6.9:time_number*6.9,mean(allcells_no_5))

xlim([0 120]);
ylim([0 10]);
xlabel('Time(seconds)');
ylabel('Number of Discrete Structures');
title('Water Injections');

%%
size(allcells_no)
