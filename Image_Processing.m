function Image_Processing
    clear
    clc
    %% Manual/Guide 
    %introduction for the user about the program
    fprintf('Welcome to the Image Processing software This is a basic algorithm for a complex software\n')
    fprintf('For the software to operate properly, ensure that the Image location and software location is same \n')
    fprintf('1)Enter the name of the image with a proper extension\n')
    fprintf('2)Choose a filter and number of times you want to apply it to the pic\n')
    fprintf('3)Specificy whether you want to save the filtered image\n')
    fprintf('4)Specify whether you want to carry out another operation or abort\n')
    fprintf('5)For the entire code 1 means yes and 0 means Abort\n')
    fprintf('Do ahead and try the software!! \n')

    %% Input for name of the file.
    %This is an answer for 1) file to process
    name = input("Enter the name of the file you want to load with it's extension in single quotes\n");

    %% Read the image
    % IM is a 512 x 512 matrix of classe uint8. 
    IM = imread(name,'pgm');
    IMO = double(IM); % defining a temporary matrix to hold the values of the input image
    [r,c] = size(IM); %used to find the size of the image Matrix
    fprintf("What would you like to do? \n")
    fprintf("Enter 1 for BOX BLURR \n")
    fprintf("Enter 2 for GAUSSIAN BLURR \n")
    fprintf("Enter 3 for EDGE DETECTION \n")
    fprintf("Enter 4 for SHARPENING \n")
    fprintf("Enter 5 for INVERSION \n")
    flag = 1; % used to determine whether user wants another function to be performed!
    while (flag == 1)
    q = input("Select a Filter\n");%providing the input select a kernal
    if q == 5 %%Bypasses the inversion filter as no kernal is required
         %% Invert
                % Here, a very simple action:
                IMO = 255-IM;
    else
     [K,n] = Kernal(q); % calling the kernal maker
    %% Extends the matrix and returns a temporary matrix to perform image processing
    for p = 1:n
        uer = IMO(1,:); % 1) uer = upper extended row = first row of our original image
        ler = IMO(r,:); % 2) ler = lower extended row = last row of our original image
        lec = IMO(:,1); % 3) lec = left extended column = left column of our original image
        rec = IMO(:,c); % 4) rec = right extended column = right column of our original image
        lec = [0.5*(IMO(1,2)+IMO(2,1));lec;0.5*(IMO(r,2)+IMO(r-1,1))];% 5) adding extra pixels to lec at the i=j positions of the matrix
        rec = [0.5*(IMO(1,c)+IMO(2,c));rec;0.5*(IMO(r,c)+IMO(r-1,c))];% this is done as we want to apply our filters on the edges of our image
        temp = [uer;IMO;ler]; % defining our temporary matrix by combing all column matrices.
        temp = [lec temp rec];
        temp = double(temp);
        %% Performs the matrix multiplication or applies the filter
            for i = 1:r
                h = i+1;
                for j = 1:c
                    z = j+1;
                    IMO(i,j) = sum(sum(K.*temp(h-1:h+1,z-1:z+1)));
                end
            end
    end
    IMO = uint8(IMO); %converting back to uint8
    end
    Image_Viewer(IMO,IM);
    fprintf("Do you want to save the Filtered Image?\n")
    s = input("If yes, enter 1 else enter 0 \n");
    if s==1
        fprintf("Save image as \n ")
        s = input("Enter the name with extension \n");
        imwrite(IMO,s,"pgm");
    end
    %% Carry checks whether the user wants another filter.
    fprintf("Do you want to carry out another filter? \n")
    flag = input("If yes enter 1 else enter 0 \n");
    end
    fprintf(' thanks for using this program! \n')
end


function [K,n] = Kernal(q)
%% Kernal maker and selector
%This function makes kernal and also throws back the required kernal
%variable q is used to select the kernal
    switch q
         %Ker stands for Kernal second letter Capital stands for the operation third stands
         %for the variation
             case 1
                 %% 1.a)BOX BLURR Kernal
                 n = input('how many times do you want to blurr the image? \n');
                 K = (1/9)*ones(3);
             case 2
                 %% 1.b) Gaussian Blurring Kernal
                 n = input('how many times do you want to blurr the image? \n');
                 K = (1/16)*[1 2 1;2 4 2;1 2 1];
             case 3
                 %% 1.c)Edge Detection
                 n = 1;
                 K = -1 *ones(3);
                 K(2,2) = 8;
             case 4
                 %% 1.d)Sharpening Kernal
                 n = input('how many times do you want to sharpen the image?\n');
                 K = [0 -1 0;-1 5 -1;0 -1 0];
               
    end
end


function Image_Viewer(IMO,IM)
    %% Displays the output
    fig = figure(1);
    fig.ToolBar="none";
    fig.MenuBar="none";
    % Two plots in one window
    subplot(1,2,1)
    image(IM);
    axis('image'); 
    axis('off');
    colormap(gray); 
    title('Original');
    
    subplot(1,2,2)
    image(IMO);
    axis('image'); 
    axis('off');
    colormap(gray);
    title('Filtered Image');
end