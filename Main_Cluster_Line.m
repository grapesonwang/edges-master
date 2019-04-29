clear all;close all;clc;

f = load('data_waqas.mat');
d = f.data_waqas;
K = [d.t];

%%%DBscan parameters
epsilon = 2; % max distance between two points to be considered in one cluster
MinPts = 15; % Minimum number of points in one cluster

%%%% Filter refelctions from ground or too high
grd_h  = -1.0; % ground reflections
sky_h = 8; % Too high (Above the buildings height) 


% Video 
filename  = ['DBSCAN_Clustering_Peng'];
writerObj = VideoWriter(filename);
Total_time  = 100; % total time of video in seconds
framerate = 2;
writerObj.FrameRate = framerate;
open(writerObj);
    
% plot figure
f1= figure('units','normalized','outerposition',[0 0 1 1]);

for k = 1:size(K,2)
    k
    %Plot measurements
    e = exist('hm');
    if e==1
        delete(hm);
        hm=[];
        delete(hc);
        hc=[];
        delete(hl);
        hl=[];
    end
    
    xyz_data = d(k).scan_mix;
    depth = xyz_data(:,1);
    horizontal = xyz_data(:,2);
    vertical = xyz_data(:,3);
    
    % 
   hm = plot3(depth,horizontal,vertical,'k.');
   hold on;
   xlabel('depth');ylabel('horizontal');zlabel('vertical');title(['Scan = ' num2str(k)]);
    
   grd_ind = find(vertical < grd_h | vertical > sky_h);
   depth(grd_ind) = [];
   horizontal(grd_ind) = [];
   vertical(grd_ind) = [];
   
   
   %% Clustering
   m_c_id = DBSCAN([depth horizontal vertical],epsilon,MinPts);

   
   N_g = max(m_c_id);
   C = linspecer(N_g);
   CM = jet(N_g);  % See the help for COLORMAP to see other choices.
   colors = distinguishable_colors(N_g,{'w'});
   
   %%%GP-model LINEAR
   noise_var = 0.1; 
   kernel  = @(x1,x2,theta) (exp(theta(1))^2 * (x1*x2')+ theta(2)^2);
   hyper = [1;sqrt(noise_var)];

   if N_g > 0
       for n=1:N_g
           ind = find(n==m_c_id);
%            subplot(2,1,1);
           max_iter = 10;  % For GP hyperparameter
           hc(n) = plot3(depth(ind),horizontal(ind),vertical(ind),'color',C(n,:),'LineStyle','none','Marker','.');
           [m_pred_lin,c_pred_lin,y_lin] = GP_Line_Extraction(horizontal(ind)',depth(ind)',noise_var,kernel,hyper,max_iter); % Predict line slope and intercept
           y_pred_lin = m_pred_lin*horizontal(ind)+c_pred_lin; 
%            subplot(2,1,2);
           hl(n) = plot3(y_pred_lin,horizontal(ind),ones(size(ind,1),1)*min(vertical(ind)),'color',C(n,:),'LineStyle','-','Linewidth',10);
       end
   end 

   F = imcapture(f1);
   writeVideo(writerObj,F);
end
close(writerObj);