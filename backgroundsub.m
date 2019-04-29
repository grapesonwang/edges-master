close all
clear all
clc

im=imread('C:\Users\uos\Desktop\LSS\tcmca-code\TCMCA\TCMCA\image\original\im_1884.png');
figure, imshow(im);
im=rgb2gray(im);
imm=double(im);
figure,imagesc(imm),colormap(gray)
hist(imm);figure(gcf);
im1=imm<=180;
figure,imagesc(im1),colormap(gray);
im2=im1.*imm;
figure,imagesc(im2),colormap(gray)