% close all
% clear all
% clc

%% Find how many pics to be processed in the directory
edgpath =  '..\image\Edge_Hough\Rec_000129'
imgpath = '..\image\Thermal\Rec_000129';

disp('If roller only, input 1, otherwise, input 0');
rollerID = input('Input your choice:  ');
disp(['Your choise is:'  num2str(rollerID)]);

if rollerID == 1
% Col = [393,  551, 725, 125]; 
% Row = [69,  69, 761, 761];

% Col = [393,  500, 700, 125]; 
% Row = [215,  215, 761, 761];
% [556.149769585253 195.744239631337;
%  622.214285714286 504.831797235023;
%  615.135944700461 757.292626728111;
%  152.684331797235 754.933179723503;
%  357.956221198157 179.228110599079]

% Col = [555 622 615 152 357];
% Row = [195 504 757 754 195];

Col = [555 622 615 152 357];
Row = [218 504 757 754 218];
end

Tolerance  = 5; % Tolerant pixels

%% Parameters
% strDate = datestr(now, 30);  %(ISO 8601)'yyyymmdd THHMMSS' 20000301T154517
startFrame = 1; 
tarDir = dir(strcat(imgpath, '\', '*.png'));
endFrame = length(tarDir);

Width = 1024;
Height = 768;

%% Video
videoname  = ['..\Local_videos\framesEdge_Rec_000129-6'];
writerObj = VideoWriter(videoname);
Total_time  = 100; % total time of video in seconds
framerate = 2;
writerObj.FrameRate = framerate;
open(writerObj);

f1= figure('units','normalized','outerposition',[0 0 1 1]);
% f1 = figure(1);
for i = startFrame:endFrame
    %% Read in a frame
    fileName = sprintf('%d',i);
    fileName = strcat('im_',fileName);
    Iorigin = imread([imgpath '\' fileName,'.png']);
    frames = Iorigin;
    
    if i == 1 && rollerID == 1
        maskImg = funcMask(Iorigin, Col, Row);
    end
    
    %% Convert to black and white image
    frames = rgb2gray(frames);
    framesBW = imbinarize(frames, 0.3); % black and white
    framesBW = framesBW & maskImg;  % Further mask the image with a polygonal mask 
    
   %% Parameters for mophorlogical processing
    se = strel('square',13);
    framesBW_DI = imdilate(framesBW, se); %dilate the bw mask
    
    frameEdge =  imread(strcat(edgpath, '\',  'im_', num2str(i), '.png'));
    for w = 1:Width
        for h = 1:Height
            if framesBW_DI(h,w) < 1
                frameEdge(h,w) = 255;
            end
        end
    end

     % use morphology to sharpen the edge
     se2 = strel('square',2);
%      frameEdge = imerode(frameEdge,se2);
%      frameEdge = imdilate(frameEdge,se2);
%      frameEdge = imdilate(frameEdge,se2);
%      frameEdge = imdilate(frameEdge,se2);
%      frameEdge = imdilate(frameEdge,se2);
  
     %strenthen the edge
    for w=1:Width
        for h=1:Height
            if frameEdge(h,w) < 240
                frameEdge(h,w) = frameEdge(h,w)*0.9;
            end
        end
    end
    
    % use Canny method to extract edges
    edgeBW = edge(frameEdge,'Canny',0.1);
    % dilate the edge
    edgeBW = imdilate(edgeBW,se2);
    
    %visualize the edges
     for w=1:Width
        for h=1:Height
            if edgeBW(h,w) == 1
               Iorigin(h,w,1) = uint8(255);
               Iorigin(h,w,2) = uint8(0);
               Iorigin(h,w,3) = uint8(0);
            end
        end
     end

    imshow(Iorigin)
    hold on;

    %% Hough Transformation to extract lines
%     [H,T,R] = hough(edgeBW,'RhoResolution',0.9,'Theta',-90:0.5:89.5); % Calculate the standard hough transform of the binary image, H is the hough transform matrix, I and R are the Angle and radius values of the hough transform
    [H,T,R] = hough(edgeBW); % Calculate the standard hough transform of the binary image, H is the hough transform matrix, I and R are the Angle and radius values of the hough transform
    P  = houghpeaks(H,55); % Extract 3 extremum points
    x = T(P(:,2)); 
    y = R(P(:,1));
    
    lines=houghlines(edgeBW,T,R,P); % Extracting line segments
    
    %% To determine the distance between rollers
    [temp_num, temp_coor, temp_diff] = paraRoller(lines);
%     allPara(i).num = temp_num;
%     allPara(i).coor = temp_coor;
%     allPara(i).diff = temp_diff;
    
    allPara(i).num = 6;
    allPara(i).coor = temp_coor(1:6);
    allPara(i).diff = temp_diff(1:3);
    
    %% Show lines in the figure
    for k = 1:length(lines)
            xy = [lines(k).point1; lines(k).point2];
            plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green'); % Draw line segments
            plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow'); %  Start point
            plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red'); % End point
    end

    F = imcapture(f1);
    writeVideo(writerObj,F);
end
 close(writerObj);   
 
 %% Compute the corresponded physical distances
standardData = load('.\Data\standardData.mat');   %standard_coor  Y coordinate of each line at X=512; standard_diff  Difference between adjacent rollers; standard_lines Start and End points of the corresponding lines
% standardData.standard_coor = round(standardData.standard_coor(1:6));
% standardData.standard_diff = round(standardData.standard_diff(1:3));

evalDist = distRoller(allPara, standardData, Tolerance);
