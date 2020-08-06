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
sphereH = 960;
sphereW = 2 * sphereH; % indicated by im2Sphere documentation
imHoriFOV = pi/2;
% set position of the center of the image in the panorama
ratio_X_shift = 0;
ratio_Y_shift_array = -0.25:0.05:0.25;

%%%%%%%%%%%%%%%%% VOC params
VOCopts.dataset='VOC2012';
VOCopts.datadir='/media/david/OS/Users/David/Documents/01 Career/01 IPCV/02/Tutored Research and Development Project/VOCdevkit/';
VOCopts.resdir='/media/david/OS/Users/David/Documents/01 Career/01 IPCV/02/Tutored Research and Development Project/VOCdevkit/VOC2012/results_Yshift_seg/';
VOCopts.localdir='/tmp/';
VOCopts.trainset='train';
VOCopts.testset='val';

% initialize main challenge paths

VOCopts.annopath=[VOCopts.datadir VOCopts.dataset '/Annotations/%s.xml'];
VOCopts.imgpath=[VOCopts.datadir VOCopts.dataset '/JPEGImages/%s.jpg'];
VOCopts.imgsetpath=[VOCopts.datadir VOCopts.dataset '/ImageSets/Main/%s.txt'];
VOCopts.clsimgsetpath=[VOCopts.datadir VOCopts.dataset '/ImageSets/Main/%s_%s.txt'];
VOCopts.clsrespath=[VOCopts.resdir 'Main/%s_cls_' VOCopts.testset '_%s.txt'];
VOCopts.detrespath=[VOCopts.resdir 'Main/%s_det_' VOCopts.testset '_%s.txt'];

% initialize segmentation task paths

VOCopts.seg.clsimgpath=[VOCopts.datadir VOCopts.dataset '/SegmentationClass/%s.png'];
VOCopts.seg.instimgpath=[VOCopts.datadir VOCopts.dataset '/SegmentationObject/%s.png'];

VOCopts.seg.imgsetpath=[VOCopts.datadir VOCopts.dataset '/ImageSets/Segmentation/%s.txt'];

VOCopts.seg.clsresdir=[VOCopts.resdir 'Segmentation/%s_%s_cls'];
VOCopts.seg.instresdir=[VOCopts.resdir 'Segmentation/%s_%s_inst'];
VOCopts.seg.clsrespath=[VOCopts.seg.clsresdir '/%s.png'];
VOCopts.seg.instrespath=[VOCopts.seg.instresdir '/%s.png'];

% initialize layout task paths

VOCopts.layout.imgsetpath=[VOCopts.datadir VOCopts.dataset '/ImageSets/Layout/%s.txt'];
VOCopts.layout.respath=[VOCopts.resdir 'Layout/%s_layout_' VOCopts.testset '.xml'];

% initialize action task paths

VOCopts.action.imgsetpath=[VOCopts.datadir VOCopts.dataset '/ImageSets/Action/%s.txt'];
VOCopts.action.clsimgsetpath=[VOCopts.datadir VOCopts.dataset '/ImageSets/Action/%s_%s.txt'];
VOCopts.action.respath=[VOCopts.resdir 'Action/%s_action_' VOCopts.testset '_%s.txt'];

% initialize the VOC challenge options

% classes

VOCopts.classes={...
    'aeroplane'
    'bicycle'
    'bird'
    'boat'
    'bottle'
    'bus'
    'car'
    'cat'
    'chair'
    'cow'
    'diningtable'
    'dog'
    'horse'
    'motorbike'
    'person'
    'pottedplant'
    'sheep'
    'sofa'
    'train'
    'tvmonitor'};

VOCopts.nclasses=length(VOCopts.classes);	

% poses

VOCopts.poses={...
    'Unspecified'
    'Left'
    'Right'
    'Frontal'
    'Rear'};

VOCopts.nposes=length(VOCopts.poses);

% layout parts

VOCopts.parts={...
    'head'
    'hand'
    'foot'};    

VOCopts.nparts=length(VOCopts.parts);

VOCopts.maxparts=[1 2 2];   % max of each of above parts

% actions

VOCopts.actions={...    
    'other'             % skip this when training classifiers
    'jumping'
    'phoning'
    'playinginstrument'
    'reading'
    'ridingbike'
    'ridinghorse'
    'running'
    'takingphoto'
    'usingcomputer'
    'walking'};

VOCopts.nactions=length(VOCopts.actions);

% overlap threshold

VOCopts.minoverlap=0.5;

% annotation cache for evaluation

VOCopts.annocachepath=[VOCopts.localdir '%s_anno.mat'];

% options for example implementations

VOCopts.exfdpath=[VOCopts.localdir '%s_fd.mat'];

%%%%%%%%%%%%%%%%% input/output paths
VOC_path = '/media/david/OS/Users/David/Documents/01 Career/01 IPCV/02/Tutored Research and Development Project/VOCdevkit/VOC2012/';
results_path = '/media/david/OS/Users/David/Documents/01 Career/01 IPCV/02/Tutored Research and Development Project/VOCdevkit/VOC2012/results_Yshift_seg/VOC2012';

for ind_ratio_Y_shift=1:numel(ratio_Y_shift_array)
    img2pano_dist(VOC_path,results_path,sphereH,sphereW,imHoriFOV,ratio_X_shift,ratio_Y_shift_array(ind_ratio_Y_shift))
end