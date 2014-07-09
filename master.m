%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%master.m (the first script that you would want to call 

%%USEFUL OUTPUT VARIABLES : The variable E contains the structure that stores all the variables,

%E(time).cell(cell_index) contains the information for a specific time
%point and a specific cell index

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%














%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%LOADING DATA AND CHANGING PATHS

clear all;% clearing the current workspace

res=0.13; % XY resolution


%%The X coordinates of the vertices are stored in the variable datax
load('/Users/eesh/Desktop/live_analysis_data/roki_injection/Image5_011113/Measurements/Membranes--vertices--Vertex-x.mat');
datax=data;

%%The Y coordinates of the vertices are stored in the variable datay
load('/Users/eesh/Desktop/live_analysis_data/roki_injection/Image5_011113/Measurements/Membranes--vertices--Vertex-y.mat'); %this loads the y 
datay=data;



cell_number=size(datay,3); 
%%cell_number : total number of traked cells in the embryo 

time_number=size(datay,1);
%%time_number : total number of time points for the injection experiment.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
















%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MAIN BODY OF THE CODE

%Here we loop over all time points and then over all the cells at each
%point of time to calculate the number of discrete unconnected structures
%in a particular cell in this embryo at a particular instance of time.

%%LOOP OVER TIME
for time=1:time_number,

    %storing the path of the image as a string, allows us to loop over images using file names differentiated only by the time point label
    image_path=strcat('/Users/eesh/Desktop/live_analysis_data/roki_injection/Image5_011113/Myosin/Image5_011113_t',sprintf('%03d',time),'_z008_c001.tif')  ;  
    %sprintf funcion: enforces integers to be formatted in a particular way
    %when converted to a string. Here it enforces the integers to be three
    %digit integers -> so 3 is '003' and 65 is '065'

    
    
    A=imread(image_path);   %Read the Image from the path
    A_hold=A;               %A_hold holds the image in the uint8 format, use this variable to output images

    A=double(A);            %Converts A to a double variable to allow more precise computation


    %%LOOP OVER CELLS IN THIS EMBRYO AT THIS POINT OF TIME
    for cell_index=1:cell_number, 

        %CHECK IF THE CELL IS TRACKED AT THIS POINT IN TIME
        if(~isnan(datax{time,2,cell_index})) 
        %The isnan check on the EDGE data is just an error check to make
        %sure our computations are done on a cell that is actually tracked
        %at the time point.    
            
            
        %USE THE RESOLUTION TO CONVERT MICRONS TO PIXELS
        tx = datax{time,2,cell_index}'./res;    %Contains the X coordinate of the vertices for this cell at this point in time
        ty = datay{time,2,cell_index}'./res;    %Contains the Y coordinate of the vertices for this cell at this point in time

        
        
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%The section that segments the image into individual cells using EDGE data 
        BW=roipoly(A_hold,tx,ty);   %BW is binary mask for the cell
        BW=double(BW);              %Converting to double for higher precision
        SE = strel('octagon',3);    %Edge erosion structure to ignore edge aberrations
        BW = imerode(BW,SE);        %Eroding the edges using the octagonal erosion structure
        
        
        E(time).cell(cell_index).ANS=BW.*A;     %Multiply element by element the BW mask to the original image.

        g = mat2gray(E(time).cell(cell_index).ANS);         %%converting from absolute values to values between zero and one

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%














%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%THRESHOLD LOOP%%%%%%%%%%%%%%%%%%%%%%%%%

       threshold_fn=[];
       
       for threshold=0.05:0.05:1,

               into_bw = im2bw(g, threshold);
               [L,num] = bwlabel(into_bw);

                %%20 is multiplied only because we need to have the indices as
                %%integers(but the size of the array which is 20 does not change
                E(time).cell(cell_index).structure(uint8(20*threshold)).num=num;    
                %(time).cell(cell_index).structure(uint8(20*threshold)).L=L;    

                %%finding the area of each of these structures

                for w=1:num
                    E(time).cell(cell_index).structure(uint8(20*threshold)).area(w) = bwarea(L==w);
                end

       end
       
       
       %If you face difficulty understanding this section please refer to:
       % http://www.johnloomis.org/ece563/notes/BinaryImages/coins/coins.html

    %%%%%%%%%%%%%%%%%%%THRESHOLD LOOP%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%







        
        end   %END THE NAN CHECK FOR UNTRACKED CELLS


    end     %END LOOP OVER CELLS


end     %END OF LOOP OVER TIME





%% NOW THE STRUCTURE VARIABLE E contains everything we need.















if 0
%%
%load('roki_image5_histogram_thresholds');
%%
if 0
    
[counts,x]=imhist(E(40).cell(20).g);
stem(x,counts);
xlim([0.0001 1]);
ylim([1 300])

%scatter(0:0.05:1,E(1).cell(1).threshold_fn)
%xlabel('threshold');
%ylabel('num');

%hx_1 = graph2d.constantline(30, 'Color',[1 0 0]);
%changedependvar(hx_1,'x');

end



%%
load('roki_image5_histogram_thresholds.mat');
%%
cell_index=6;
t=45;
%%
for t=30:60,

discrete = im2uint8(E(t).cell(cell_index).structure(7).L/E(t).cell(cell_index).structure(7).num);

continuous = uint8(E(t).cell(cell_index).ANS);

M=[discrete continuous];

imshow(M);

imwrite(M,jet,strcat('cell',num2str(cell_index),'_time',num2str(t),'.tif'));

end
%%
for q=1:19,
    X=find(E(time).cell(cell_index).structure(7).area >4);
        s=size(X,2);
    scatter(q*5,E(40).cell(cell_index).structure(q).num)
    hold on;
end


xlabel('Threshold(%)')
ylabel('No. of Discrete Unconnected Structures');
title('AT TIME OF INJECTION of ROK inhibitor');

%% you must save E using save -v7.3 roki_image1_histogram_thresholds
%%show E(time).cell(10).structure(12).area E(40).cell(30).structure(12).area
%%results for wildtype they are
%%VERY ENCOURAGING

%E(60).cell(5).structure(10).area

%imshow(uint8(E(42).cell(3).ANS))
%%http://www.johnloomis.org/ece563/notes/BinaryImages/coins/coins.html


end