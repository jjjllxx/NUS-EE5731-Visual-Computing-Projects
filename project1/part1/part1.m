clear;clc;
colorImage=imread('lena512color.tiff');  
rawgrayImage=rgb2gray(colorImage);grayImage=double(rawgrayImage);
[m, n]=size(grayImage);

%Sobel Kernel
figure(1)
subplot(231);imshow(rawgrayImage);title('Original image');
for t=1:5
    k=t;
    sobelImage=zeros(m,n);
    sobel_kernel_x=zeros(2*k+1);sobel_kernel_x(1,1)=-1;sobel_kernel_x(2*k+1,1)=-1;sobel_kernel_x(k+1,1)=-2;sobel_kernel_x(:,2*k+1)=-sobel_kernel_x(:,1);
    sobel_kernel_y=zeros(2*k+1);sobel_kernel_y(1,1)=1;sobel_kernel_y(1,2*k+1)=1;sobel_kernel_y(1,k+1)=2;sobel_kernel_y(2*k+1,:)=-sobel_kernel_y(1,:);
%     sobel_kernel_x=[-1,0,1;-2,0,2;-1,0,1];sobel_kernel_y=[1 2 1;0 0 0;-1 -2 -1];
    for i=1+k:m-k
        for j=1+k:n-k
%             Gx_sobel=grayImage(i+1,j-1)+2*grayImage(i+1,j)+grayImage(i+1,j+1)-grayImage(i-1,j-1)-2*grayImage(i-1,j)-grayImage(i-1,j+1);
%             Gy_sobel=grayImage(i-1,j-1)+2*grayImage(i,j-1)+grayImage(i+1,j-1)-grayImage(i-1,j+1)-2*grayImage(i,j+1)-grayImage(i+1,j+1);
            Gx_sobel=sum(sum(grayImage(i-k:i+k,j-k:j+k).*sobel_kernel_x));
            Gy_sobel=sum(sum(grayImage(i-k:i+k,j-k:j+k).*sobel_kernel_y));
            sobelImage(i,j)=sqrt(Gx_sobel^2+Gy_sobel^2);
        end
    end
    figure(1)
    subplot(2,3,t+1);imshow(mat2gray(sobelImage));title(['Sobel Kernel (size=',num2str(2*k+1),')']);
end

%Gaussian Kernel
figure(2)
subplot(231);imshow(rawgrayImage);title('Original image');
for t=1:5
    k=t;
    sigma=k+0.5;gaussianImage=zeros(m,n);
    gaussian_kenerl=zeros(2*k+1,2*k+1);
    for i=1:2*k+1
        for j=1:2*k+1
            gaussian_kenerl(i,j)=1/(2*pi*sigma^2)*exp(-((i-k-1)^2+(j-k-1)^2)/(2*sigma^2));
        end
    end
    gaussian_kenerl=gaussian_kenerl/sum(sum(gaussian_kenerl));
%     gaussian_kenerl=[0.0947416 0.118318 0.0947416;0.118318 0.147761 0.118318; 0.0947416 0.118318 00947416];
    for i=1+k:m-k
        for j=1+k:n-k
            gaussianImage(i,j)=sum(sum(grayImage(i-k:i+k,j-k:j+k).*gaussian_kenerl));
        end
    end
    figure(2)
    subplot(2,3,t+1);imshow(mat2gray(gaussianImage));title(['Gaussian Kernel (size=',num2str(2*k+1),')']);
end

%The 5 Haar-like masks
maskscale=input('set the scale of the masks ');
figure(3)
subplot(231);imshow(rawgrayImage);title('Original image');
type1=[-ones(maskscale,maskscale) ones(maskscale,maskscale)];
type2=[-ones(maskscale,maskscale);ones(maskscale,maskscale)];
type3=[ones(maskscale,maskscale) -ones(maskscale,maskscale) ones(maskscale,maskscale)];
type4=[ones(maskscale,maskscale);-ones(maskscale,maskscale);ones(maskscale,maskscale)];
type5=[-ones(maskscale,maskscale) ones(maskscale,maskscale);ones(maskscale,maskscale) -ones(maskscale,maskscale)];
feature1=zeros(m-maskscale+1,m-2*maskscale+1);feature2=zeros(m-2*maskscale+1,n-maskscale+1);
feature3=zeros(m-maskscale+1,m-3*maskscale+1);feature4=zeros(m-3*maskscale+1,m-maskscale+1);
feature5=zeros(m-2*maskscale+1,m-2*maskscale+1);
for i=1:m-maskscale+1
    for j=1:n-2*maskscale+1
        feature1(i,j)=sum(sum(grayImage(i:i+maskscale-1,j:j+2*maskscale-1).*type1));
    end
end
for i=1:m-2*maskscale+1
    for j=1:n-maskscale+1
        feature2(i,j)=sum(sum(grayImage(i:i+2*maskscale-1,j:j+maskscale-1).*type2));
    end
end
for i=1:m-maskscale+1
    for j=1:n-3*maskscale+1
        feature3(i,j)=sum(sum(grayImage(i:i+maskscale-1,j:j+3*maskscale-1).*type3));
    end
end
for i=1:m-3*maskscale+1
    for j=1:n-maskscale+1
        feature4(i,j)=sum(sum(grayImage(i:i+3*maskscale-1,j:j+maskscale-1).*type4));
    end
end
for i=1:m-2*maskscale+1
    for j=1:n-2*maskscale+1
        feature5(i,j)=sum(sum(grayImage(i:i+2*maskscale-1,j:j+2*maskscale-1).*type5));
    end
end
figure(3)
subplot(232);imshow(mat2gray(feature1));title(['Haar-like Type ',num2str(1*maskscale),'*',num2str(2*maskscale)]);
subplot(233);imshow(mat2gray(feature2));title(['Haar-like Type ',num2str(2*maskscale),'*',num2str(1*maskscale)]);
subplot(234);imshow(mat2gray(feature3));title(['Haar-like Type ',num2str(1*maskscale),'*',num2str(3*maskscale)]);
subplot(235);imshow(mat2gray(feature4));title(['Haar-like Type ',num2str(3*maskscale),'*',num2str(2*maskscale)]);
subplot(236);imshow(mat2gray(feature5));title(['Haar-like Type ',num2str(2*maskscale),'*',num2str(2*maskscale)]);