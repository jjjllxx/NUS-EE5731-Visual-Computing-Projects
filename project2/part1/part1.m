clc;clear;close;
% lambda can be set here
lambda=200;

% % get the image information
source_color=[0,0,255];sink_color=[245,210,110];
colormap=[sink_color;source_color];
img=imread('1.png');
[H,W,~]=size(img);
pixel_num=H*W;

% segclass, unary and labelcost
segclass = zeros(pixel_num,1);
unary = zeros(2,pixel_num);
labelcost = [0,1;1,0];
num=0;link=zeros(2,pixel_num*2);

for row = 0:H-1
  for col = 0:W-1
    pixel = 1+row*W+col;
% data term
    I = double(reshape(img(row+1, col+1,:),1,3));
    unary(1, pixel) = mean(abs(I-colormap(1,:)));
    unary(2, pixel) = mean(abs(I-colormap(2,:)));
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

% use GCMex
addpath('.../GCMex')
[labels,~,~] = GCMex(segclass, single(unary), pairwise, single(labelcost),0);
labels=reshape(labels,W,H)';
result=zeros(H,W,3);

% draw the result
for row = 1:H
    for col = 1:W
        result(row, col, :) = colormap(labels(row,col)+1,:);
    end
end

% show the result
figure;
imshow(uint8(result));
title(['Output Image(lambda=',num2str(lambda),')'])
