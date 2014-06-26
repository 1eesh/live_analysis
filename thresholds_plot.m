load('water_image21_histogram_thresholds');
%%
imhist(uint8(E(42).cell(3).ANS))
xlim([0.001 1]);
ylim([0 500]);

%%
for i=1:time_number,
    
    X=find(E(i).cell(40).structure(7).area >4);
    s=size(X,2);
    scatter(i,s)
    hold on;
    
end


xlabel('Time Step');
ylabel('Number of Discrete Structures');
title('Rok Injection Cell');

%%

 [counts,x] = imhist(E(2).cell(45).g);

    wmean(x(2:size(x,1),:),counts(2:size(x,1),:))
%%
for i=1:time_number,
    
    [counts,x] = imhist(uint8(E(i).cell(40).ANS));
    weigted_mean=wmean(x(2:size(x,1),:),counts(2:size(x,1),:));
     
    V = var(x(2:size(x,1),:),counts(2:size(x,1),:)) ;
 %(2:size(x,1),:) this ignores mountain of zeros corresponding black
 %intensity at beginning
    
    
    scatter(i,V)
    hold on;
    
end

%%

[counts,x] = imhist(E(60).cell(10).g);
    weigted_mean=wmean(x(2:size(x,1),:),counts(2:size(x,1),:));
     
    V = var(x(2:size(x,1),:),counts(2:size(x,1),:)) ;