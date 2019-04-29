clear all
close all
clc
% Demo for Structured Edge Detector (please see readme.txt first).

%% set opts for training (see edgesTrain.m)
opts=edgesTrain();                % default options (good settings)
opts.modelDir='models/';          % model will be in models/forest
opts.modelFnm='modelBsds';        % model name
opts.nPos=5e5; opts.nNeg=5e5;     % decrease to speedup training
opts.useParfor=0;                 % parallelize if sufficient memory

%% train edge detector (~20m/8Gb per tree, proportional to nPos/nNeg)
tic, model=edgesTrain(opts); toc; % will load model if already trained

%% set detection parameters (can set after training)
model.opts.multiscale=0;          % for top accuracy set multiscale=1
model.opts.sharpen=2;             % for top speed set sharpen=0
model.opts.nTreesEval=4;          % for top speed set nTreesEval=1
model.opts.nThreads=4;            % max number threads for evaluation
model.opts.nms=0;                 % set to true to enable nms

%% evaluate edge detector on BSDS500 (see edgesEval.m)
if(0), edgesEval( model, 'show',1, 'name','' ); end

%% detect edge and visualize results
%%
imgpath = '.\image\Thermal\Rec_000112';
startFrame = 1; 
tarDir = dir(strcat(imgpath, '\', '*.png'));
endFrame = length(tarDir);


%% Folder for processed images
if ~exist('image\Edge_Hough\Rec_000112','dir')
    mkdir('image\Edge_Hough\Rec_000112');
    disp('successfully create directory image\Edge_Hough\Rec_000112!');
end


% f1= figure(1);
% f1= figure('units','normalized','outerposition',[0 0 1 1]);
% axis off
for i = startFrame:endFrame
    fileName = sprintf('%d',i);
    fileName = strcat('im_',fileName);
    [frames, colormap] = imread([imgpath '\' fileName,'.png']);
    
    tic, E=edgesDetect(frames,model); toc
    F = 1 - E;
    
    image_name=strcat('.\image\Edge_Hough\Rec_000112\im_', num2str(i), '.png');  
    imwrite(F,image_name,'png');
end

disp('all images are written into directory image\Edge_Hough\Rec_000112')
