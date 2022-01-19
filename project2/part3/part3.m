clc;clear;close all;

% camera parameter is saved as .mat file
load('camera.mat')
K1 = camera(1:3,:);K2 = camera(8:10,:);
R1 = camera(4:6,:);R2 = camera(11:13,:);
T1 = camera(7,:);T2 = camera(14,:);

% imread image
left=double(imread('left.png'));
right= double(imread('right.png'));
tic

% get the image size
[H,W,~] = size(left);pixel_num=H*W;

% disparity range
dmin=0; dmax=0.01; k=0:100; m=100;
disparity = (m-k)/m*dmin+k/m*dmax;

% parameter in paper
ws=5/(dmax-dmin);
eta = 0.05*(dmax-dmin);
sigma=10;epsilon=50;

% labelcost
[a, b]=meshgrid(disparity);
labelcost=min(abs(a-b),eta);
unary = zeros(length(disparity),pixel_num);
num=0;link=zeros(2,pixel_num);weight=zeros(1,pixel_num);

% neighbor for each x
for row=0:H-1
  for col=0:W-1
    pixel=1+row*W+col;   
% prior term
    if row+1 < H
        num=num+1;
        link(1,num)=pixel;link(2,num)=1+col+(row+1)*W;
        weight(num)=sum((left(row+1,col+1,:)-left(row+2,col+1,:)).^2);
        weight(num)=double(1./(sqrt(weight(num))+epsilon));
    end
    if row > 0
        num=num+1;
        link(1,num)=pixel;link(2,num)=1+col+(row-1)*W;
        weight(num)=sum((left(row+1,col+1,:)-left(row,col+1,:)).^2);
        weight(num)=double(1./(sqrt(weight(num))+epsilon));
    end 
    if col+1 < W
        num=num+1;
        link(1,num)=pixel;link(2,num)=1+(col+1)+row*W;
        weight(num)=sum((left(row+1,col+1,:)-left(row+1,col+2,:)).^2);
        weight(num)=double(1./(sqrt(weight(num))+epsilon));
    end
    if col > 0
        num=num+1;
        link(1,num)=pixel;link(2,num)=1+(col-1)+row*W;
        weight(num)=sum((left(row+1,col+1,:)-left(row+1,col,:)).^2);
        weight(num)=double(1./(sqrt(weight(num))+epsilon));
    end
  end
end

% data term
[x,y]=meshgrid(1:H,1:W);
% vectorize the coordinate
x=x(:)';y=y(:)'; 
Xorigin=[y;x;ones(1,H*W)];

% get pixel info
p_im1 = impixel(left, y, x);

for d=1:length(disparity)
% rectify
    Xprime=K2*R2'*R1/K1*Xorigin+disparity(d)*K2*R2'*(T1-T2)';
    Xprime=round(Xprime./Xprime(3,:));
% find the related point in right image
    p_img2=impixel(right, Xprime(1, :), Xprime(2, :));
    p_img2(isnan(p_img2))=0;
    unary(d, :)=(sigma./(sigma + sqrt(sum((p_im1-p_img2).^2, 2))));
end

% initialization
pairwise_old=sparse(link(1,:),link(2,:),weight);
[link1, link2, weight_new]=find(pairwise_old);

% calculate u_lambda and lambda then pairwise
neighbor_num=[[2,3*ones(1, W-2),2],repmat([3,4*ones(1, W-2),3],1,H-2),[2,3*ones(1, W-2),2]];
u_lambda=neighbor_num./sum(pairwise_old);
lambda=ws.*u_lambda(link1).*weight_new';
pairwise=sparse(link1,link2,lambda);

% normalization for data term
unary=1-unary./max(unary);
[~, pos]=min(unary); segclass=pos-1;

% run GCMex
addpath('.../GCMex')
[labels,~,~] = GCMex(segclass, single(unary), pairwise, single(labelcost),0);
result=reshape(labels,W,H)';

% show the result
figure
imshow(uint8(result), [min(labels), max(labels)]);
title('Depth from Stereo')
toc