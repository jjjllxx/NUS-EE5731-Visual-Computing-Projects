clc;clear;close all;
% The folder 'vlfeat-0.9.21' should be added to path before running
run('vlfeat-0.9.21/toolbox/vl_setup')
tic
img1 = imread('im01.jpg');
img2 = imread('im02.jpg');
img3 = imread('im03.jpg');
img4 = imread('im04.jpg');
img5 = imread('im05.jpg');
[loc1,des1] = vl_sift(single(rgb2gray(img1))) ;
[loc2,des2] = vl_sift(single(rgb2gray(img2))) ;
[loc3,des3] = vl_sift(single(rgb2gray(img3))) ;
[loc4,des4] = vl_sift(single(rgb2gray(img4))) ;
[loc5,des5] = vl_sift(single(rgb2gray(img5))) ;

allmatched12=vl_ubcmatch(des1,des2,1.4);
img12 = ransac1(loc1,loc2,img1,img2,allmatched12);

[loc12,des12] = vl_sift(single(rgb2gray(img12))) ;
allmatched123 = vl_ubcmatch(des12,des3,1.4);
img123 = ransac2(loc12,loc3,img12,img3,allmatched123);

[loc123,des123]=vl_sift(single(rgb2gray(img123))) ;
allmatched1234 = vl_ubcmatch(des123,des4,1.4);
img1234 = ransac2(loc123,loc4,img123,img4,allmatched1234);
 
[loc1234,des1234]=vl_sift(single(rgb2gray(img1234))) ;
allmatched12345 = vl_ubcmatch(des1234,des5,1.4);
img12345 = ransac2(loc1234,loc5,img1234,img5,allmatched12345);
toc