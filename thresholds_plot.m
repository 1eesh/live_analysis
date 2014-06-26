clear all;
load('water_image21_histogram_thresholds');
%%
imhist(uint8(E(42).cell(3).ANS))
xlim([0.001 1]);
ylim([0 500]);

%%
%%THIS IS FOR NO OF DISCRETE STRUCTURES
%The matrix rows of allcells_no contain the no of structures for each cell
%at a given point in time. and the so there are cell_number rows and
%time_number columns

allcells_no=[];
for cell_index=1:cell_number,
   
         
    cell_no=[];
    
    s_prev=10; %%this is a construct for error checking when EDGE fails to track, I just add the number in the last tracked cell
for time=1:time_number,
    
    if(~isempty(E(time).cell(cell_index).g))
   
        X=find(E(time).cell(cell_index).structure(7).area >4);
        s=size(X,2);
        s_prev=s;
    
    else
        s=s_prev;
        
    end%end the isempty check for array
    
        
    cell_no = [cell_no s];
    
    hold on;
    
end

allcells_no=[ allcells_no ; cell_no];


    
    
end

    scatter(1:1:time_number,floor(mean(allcells_no)))


xlabel('Time Step');
ylabel('Number of Discrete Structures');
title('Rok Inhibitor Injections');














%%
%%VARIANCE

allcells_no=[];
for cell_index=1:cell_number,
   
         
    cell_no=[];
    
    s_prev=0; %%this is a construct for error checking when EDGE fails to track, I just add the number in the last tracked cell
for time=1:time_number,
    
    if(~isempty(E(time).cell(cell_index).ANS))
   %
        [counts,x] = imhist(uint8(E(time).cell(cell_index).ANS));
        
        if(sum(counts)==0) s=s_prev;
        else   s = var(x(2:size(x,1),:),counts(2:size(x,1),:)) ;
        end
    %
   
      s_prev=s;
    
    else
        s=s_prev;
        
    end%end the isempty check for array
    
        
    cell_no = [cell_no s];
    
    hold on;
    
end

allcells_no=[ allcells_no ; cell_no];


    
    
end

    scatter(1:1:time_number,(mean(allcells_no)))


xlabel('Time Step');
ylabel('Variance');
title('Water Injections');




















 
%%
for time=1:time_number,
    
    [counts,x] = imhist(E(time).cell(21).g);
    %weigted_mean=wmean(x(2:size(x,1),:),counts(2:size(x,1),:));
     
    V = var(x(2:size(x,1),:),counts(2:size(x,1),:)) ;
 %(2:size(x,1),:) this ignores mountain of zeros corresponding black
 %intensity at beginning
    
    
    scatter(time,V)
    hold on;
    
end

%%

[counts,x] = imhist(E(60).cell(10).g);
    weigted_mean=wmean(x(2:size(x,1),:),counts(2:size(x,1),:));
     
    V = var(x(2:size(x,1),:),counts(2:size(x,1),:)) ;