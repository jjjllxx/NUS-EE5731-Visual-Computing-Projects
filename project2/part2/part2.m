clc;clear;close;
% get the image information
left=double(imread('left2.png'));
right= double(imread('right2.png'));
[H,W,~] = size(left);
pixel_num=H*W;

% lambda and disparity can be changed for different effect
lambda=10; 
disparity=64;

% labelcost
[a, b]=meshgrid(1:disparity);
labelcost=log(((a-b).^2)+1);

segclass=ones(pixel_num,1);
unary=zeros(disparity,pixel_num);
link=zeros(2,pixel_num);weight=zeros(1,pixel_num);num=0;
tic

for row=0:H-1
  for col=0:W-1
    pixel=1+row*W+col;
% data term
    I = double(reshape(left(row+1, col+1,:),1,3));
    for d=1:disparity
        if col+1-d>0
            Iprime=double(reshape(right(row+1, col+1-d,:),1,3));
            unary(d, pixel)=sqrt(sum((I-Iprime).^2));
        else 
            unary(d, pixel)=1000;
        end
    end
% prior term
    if row+1 < H
        num=num+1;
        link(1,num)=pixel;link(2,num)=1+col+(row+1)*W;
    end
    if row-1 >= 0
        num=num+1;
        link(1,num)=pixel;link(2,num)=1+col+(row-1)*W;
    end 
    if col+1 < W
        num=num+1;
        link(1,num)=pixel;link(2,num)=1+(col+1)+row*W;
    end
    if col-1 >= 0
        num=num+1;
        link(1,num)=pixel;link(2,num)=1+(col-1)+row*W;
    end
  end
end

% build neighbor relationship
pairwise=sparse(link(1,:),link(2,:),lambda);

% run GCMex
addpath('.../GCMex')
[labels,~,~]=GCMex(segclass, single(unary),pairwise,single(labelcost),1);
result=reshape(labels,W,H)';
toc

% show the result
figure
imshow(uint8(result), [1, disparity]);
title(['Depth from Rectified Stereo Images(lambda=',num2str(lambda),')'])
