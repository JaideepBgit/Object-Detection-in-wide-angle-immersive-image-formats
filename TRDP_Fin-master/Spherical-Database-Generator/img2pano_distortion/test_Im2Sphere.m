%% pcl: test im2Sphere function
clear all;
close all;

% add Pano2Context path and back
addpath('../Pano2Context/PanoBasic');
cd('../Pano2Context/PanoBasic')
add_path; % Pano2Context functions
cd('../../img2pano_distortion')

im = double(imread('..\Pano2Context\PanoBasic\data\buf_74_17_44_561130.pgm')); % seems im2Sphere does not accept uint8 data

imHoriFOV = pi/3;
sphereH = 960;
sphereW = 2*sphereH; % indicated by im2Sphere documentation

% set position of the center of the view in the panoramic image
coords = [sphereW/2+200 sphereH/2+300];
% transform to uv notation
[ uv ] = coords2uv( coords, sphereW, sphereH );

figure
imshow(uint8(im));

[sphereImg, validMap] = im2Sphere(im, imHoriFOV, sphereW, sphereH, uv(1), uv(2) );
figure
imshow(uint8(sphereImg));
figure
imagesc(validMap);

% try effect of fov in the result
figure
for imHoriFOV = 0.2: 0.1 : pi/2
    [sphereImg, validMap] = im2Sphere(im, imHoriFOV, sphereW, sphereH, uv(1), uv(2) );
    imshow(uint8(sphereImg));
    %figure
    %imagesc(validMap);
    pause
   
end

% try effect of y position in the result
imHoriFOV = pi/3;
figure
for y = 200:200: sphereH
    coords = [sphereW/2 y];
    [ uv ] = coords2uv( coords, sphereW, sphereH );
    [sphereImg, validMap] = im2Sphere(im, imHoriFOV, sphereW, sphereH, uv(1), uv(2));
    imshow(uint8(sphereImg));
    pause
end
