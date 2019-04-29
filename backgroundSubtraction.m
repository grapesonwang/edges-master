function im2 = backgroundSubtraction(im)
im=rgb2gray(im);
imm=double(im);
im1=imm<=180;
im2(:,:,1)=im1.*imm;
im2(:,:,2)=im2(:,:,1);
im2(:,:,3)=im2(:,:,1);
end