clear;clc;close;
fid = fopen('Road/cameras.txt');
C=textscan(fid,'%f %f %f');
fclose(fid);
C=cell2mat(C);C=C(2:end,:);
for i=0:140
    K{i+1}=C(1+i*7:3+i*7,:);
    R{i+1}=C(4+i*7:6+i*7,:);
    T{i+1}=C(7+i*7,:);
end

addpath('../GCMex')
img1 = imread('../Road/src/test0000.jpg');
[H,W,~] = size(img1);
pixel_num=H*W;

% frame number to process(should be an even number)
frame_num=40;
image_num=140;
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
neighbor_num=[[2,3*ones(1, W-2),2],repmat([3,4*ones(1, W-2),3],1,H-2),[2,3*ones(1, W-2),2]];

% data term
[x,y]=meshgrid(1:H,1:W);
% vectorize the coordinate
x=x(:)';y=y(:)';
Xorigin=[y;x;ones(1,H*W)];


for first=0:image_num
    tic
    % read img1
    disp(['Processing image', num2str(image_num),' ....'])
    fid=['../Road/src/test',repmat('0',1,4-length(num2str(first))),num2str(first),'.jpg'];
    img1 = double(imread(fid));
    p_img1 = impixel(img1,y,x);
    
    for row=0:H-1
        for col=0:W-1
            pixel=1+row*W+col;
            % prior term
            if row+1 < H
                num=num+1;
                link(1,num)=pixel;link(2,num)=1+col+(row+1)*W;
                weight(num)=sum((img1(row+1,col+1,:)-img1(row+2,col+1,:)).^2);
                weight(num)=double(1./(sqrt(weight(num))+epsilon));
            end
            if row > 0
                num=num+1;
                link(1,num)=pixel;link(2,num)=1+col+(row-1)*W;
                weight(num)=sum((img1(row+1,col+1,:)-img1(row,col+1,:)).^2);
                weight(num)=double(1./(sqrt(weight(num))+epsilon));
            end
            if col+1 < W
                num=num+1;
                link(1,num)=pixel;link(2,num)=1+(col+1)+row*W;
                weight(num)=sum((img1(row+1,col+1,:)-img1(row+1,col+2,:)).^2);
                weight(num)=double(1./(sqrt(weight(num))+epsilon));
            end
            if col > 0
                num=num+1;
                link(1,num)=pixel;link(2,num)=1+(col-1)+row*W;
                weight(num)=sum((img1(row+1,col+1,:)-img1(row+1,col,:)).^2);
                weight(num)=double(1./(sqrt(weight(num))+epsilon));
            end
        end
    end
    
    pairwise_old=sparse(link(1,:),link(2,:),weight);
    [link1, link2, weight_new]=find(pairwise_old);
    u_lambda=neighbor_num./sum(pairwise_old);
    lambda=ws.*u_lambda(link1).*weight_new';
    pairwise=sparse(link1,link2,lambda);
    
    % set process frame range
    frame_lower=max(0,first-frame_num/2);
    frame_upper=min(first + frame_num/2,140);
    frame_range=[frame_lower:first-1,first+1:frame_upper];
    
    % initialize unary
    unary=zeros(length(disparity), pixel_num);
    K1=K{first+1};R1=R{first+1};T1=T{first+1};
    
    for second = frame_range
        % imread img2
        fid=['../Road/src/test',repmat('0',1,4-length(num2str(second))),num2str(second),'.jpg'];
        img2=double(imread(fid));
        K2=K{second+1};R2=R{second+1};T2=T{second+1};
        % data term
        pc = zeros(length(disparity), pixel_num);
        for d=1:length(disparity)
            Xprime=K2*R2'*R1/K1*Xorigin+disparity(d)*K2*R2'*(T1-T2)';
            Xprime=round(Xprime./Xprime(3,:));
            % find the related point in right image
            p_img2=impixel(img2, Xprime(1,:), Xprime(2,:));
            p_img2(isnan(p_img2))=0;
            pc(d,:)=(sigma./(sigma+sqrt(sum((p_img1-p_img2).^2, 2))));
        end
        unary=unary+pc;
    end
    
    % data term normalization
    unary=1-unary./max(unary);
    [~,pos]=min(unary);
    segclass=pos-1;
    % run GEMex
    [labels, ~, ~] = GCMex(segclass, single(unary), pairwise, single(labelcost),1);
    result = reshape(labels,W,H)';
    fid=['../Road/result/f',repmat('0',1,4-length(num2str(first))),num2str(first),'.jpg'];
    imwrite(mat2gray(result), fid);
    disp(['Image ',num2str(first),' is finished and saved'])
    toc
end
disp(['Finished.', num2str(image_num),' images are in result folder'])
