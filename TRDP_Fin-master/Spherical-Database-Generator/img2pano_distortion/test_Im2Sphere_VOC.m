%% pcl: test im2Sphere function for VOC images
clear all;
close all;

%%%%%%%%%%%%%%%%% path operations
% add Pano2Context and VOC paths
% addpath('/PanoBasic');
cd('../PanoBasic')
add_path; % Pano2Context functions
cd('../img2pano_distortion')
addpath([ '../VOCdevkit/VOCcode']);

%%%%%%%%%%%%%%%%%% common parameters
sphereH = 1500;
sphereW = 2 * sphereH; % indicated by im2Sphere documentation
imHoriFOV = pi/2;


%%%%%%%%%%%%%%%%% input/output paths
VOC_path = '/Users/jaideep/Documents/UAM/TRDP/code/SphereNet-pytorch-master/spherenet/trdp_database_code_org_copy/VOCdevkit/VOC2012';
results_path = '/Users/jaideep/Documents/UAM/TRDP/code/SphereNet-pytorch-master/spherenet/trdp_database_code_org_copy/VOCdevkit/VOC2012/results_Yshift/VOC2012';
dataset_file_ext =2;
max_val_dist = 0.5;
img2pano_dist(VOC_path,results_path,sphereH,sphereW,imHoriFOV,dataset_file_ext,max_val_dist)








