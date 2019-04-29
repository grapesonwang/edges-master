close all
clear all
clc

for n = 1:3265
    Iorigin=imread(['Rec-000132-',num2str(n),'.jpg']); %Read thermal video
    I=Iorigin;
    I=rgb2gray(I);
    Ibw=im2bw(I,0.7); %black and white
    se = strel('square',13);
    Ibwdi = imdilate(Ibw,se); %dilate the bw mask
    
    %read the edges video and apply the bw mask
    Iedge=imread(['E:\²©Ê¿\LibertySteel_Project\LibertySteel_Video\Rec-000132\Edge\Rec-000132-',num2str(n),'.jpg']);
    for w=1:1024
        for h=1:768
            if Ibwdi(h,w)<1;
                Iedge(h,w)=255;
            end
        end
    end

     % use morphology to sharpen the edge
     se2 = strel('square',2);
     Iedge = imerode(Iedge,se2);
     Iedge = imdilate(Iedge,se2);
     Iedge = imdilate(Iedge,se2);
     Iedge = imdilate(Iedge,se2);
     Iedge = imdilate(Iedge,se2);
  
     %strenthen the edge
    for w=1:1024
        for h=1:768
            if Iedge(h,w)<240;
                Iedge(h,w)=Iedge(h,w)*0.9;
            end
        end
    end
    
    % use Canny method to extract edges
    test=edge((Iedge),'Canny',0.1);
    % dilate the edge
    test = imdilate(test,se2);
    
    %visualize the edges
     for w=1:1024
        for h=1:768
            if test(h,w)==1;
               Iorigin(h,w,1)=255;
               Iorigin(h,w,2)=0;
               Iorigin(h,w,3)=0;
            end
        end
     end
     
     imshow(Iorigin)

end