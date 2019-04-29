
close all;
clear all;
clc

I  = imread('..\image\Thermal\Rec_000129\im_119.png');
I  = rgb2gray(I);
figure;
subplot(1,3,1);
imshow(I);
BW = edge(I,'canny');  % Canny extracts image boundary and returns binary image (boundary 1, otherwise 0)
[H,T,R] = hough(BW); % Calculate the standard hough transform of the binary image, H is the hough transform matrix, I and R are the Angle and radius values of the hough transform
subplot(1,3,2);
imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit'); % Hough transform
xlabel('\theta'), ylabel('\rho');
axis on,axis square,hold on;
P  = houghpeaks(H,55); % Extract 3 extremum points
x = T(P(:,2)); 
y = R(P(:,1));
plot(x,y,'s','color','white'); % Mark the extremum
lines=houghlines(BW,T,R,P); % Extracting line segments
subplot(1,3,3);
imshow(I), hold on;
for k = 1:length(lines)
xy = [lines(k).point1; lines(k).point2];
 plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green'); % Draw line segments
plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow'); %  Start point
plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red'); % End point
end
