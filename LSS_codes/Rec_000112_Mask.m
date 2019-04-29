close all
clear all
clc
% LstartPoint = [393, 125];  % Start and End column coordinates
% LendPoint = [69, 761];     % Start and End row coordinates
% 
% RstartPoint = [551, 725];
% RendPoint = [69, 761];

%% Read in the one of the image
imgpath = '..\image\Thermal\Rec_000129';
frameID = 1;
fileName = strcat('im_',num2str(frameID));
Img = imread(strcat(imgpath, '\', fileName, '.png'));

%% White template
% mask = uint8(ones(768,1024) *255);
%%
disp(strcat('There are two ways to determined the mask',   ...
    '1. Used fixed coordinates to determine the mask, input 1',  ...
    '2. Manually determined the mask, input 2'));

Num = input('Input your choice:');
disp(['You input number is:',num2str(Num)]);
if Num == 1
%% Fixed coordinates mask
    mask = Img(:, :, 1);
    Col = [393,  551, 725, 125]; 
    Row = [69,  69, 761, 761];

    BW = roipoly(mask, Col, Row);
    figure, imshow(BW);
    phi=2*2*(0.5-BW);
    figure;
    imagesc(Img,[0,255]);
    colormap(gray);
    hold on
    axis off;
    axis equal;
    [c,h] = contour(phi,[0 0],'r');
    hold off;
elseif Num ==2
%% Manually determine the mask
    figure;
    imagesc(Img,[0,255]);
    colormap(gray);
    hold on
    axis off;
    axis equal;

    text(150,60,'Left click to get points, right click to get end point','FontSize',[12],'Color', 'r');

    BW=roipoly;
    phi=2*2*(0.5-BW);
    hold on;
    [c,h] = contour(phi,[0 0],'r');
    hold off;
end




