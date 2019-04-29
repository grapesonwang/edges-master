close all
clear all
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
%I = imread('peppers.png');

%% video
% Video 
videoname  = ['Local_videos\Edge_Rec_000129'];
writerObj = VideoWriter(videoname);
Total_time  = 100; % total time of video in seconds
framerate = 2;
writerObj.FrameRate = framerate;
open(writerObj);

imgpath = 'image\Thermal\Rec_000129';
startFrame = 1; 
endFrame = 207; 

f1= figure('units','normalized','outerposition',[0 0 1 1]);

for i = startFrame:endFrame
    fileName = sprintf('%d',i);
    fileName = strcat('im_',fileName);
    [frames, colormap] = imread([imgpath '\' fileName,'.png']);
    
%     frames = backgroundSubtraction(frames);
    
    tic, E=edgesDetect(frames,model); toc
    im(1-E);

    F = imcapture(f1);
    
    writeVideo(writerObj,F);
end
close(writerObj);




