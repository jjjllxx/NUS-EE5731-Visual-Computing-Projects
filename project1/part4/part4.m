clc;clear;close all;
h1=im2double(imread('im01.jpg'));h2=im2double(imread('im02.jpg'));
imagesc(h1);title('Choose 4 Homography Points.')
[x1,y1]=ginput(4);
imagesc(h2);title('Choose 4 Homography Points.')
[x2,y2]=ginput(4);
close
%h1 to h2
A_matrix=zeros(8);
b_matrix=[x1(1);y1(1);x1(2);y1(2);x1(3);y1(3);x1(4);y1(4)];
for i=1:4
    A_matrix(2*i-1:2*i,:)=[x2(i) y2(i) 1 0 0 0 -x1(i)*x2(i) -x1(i)*y2(i);0 0 0 x2(i) y2(i) 1 -y1(i)*x2(i) -y1(i)*y2(i)];
end
h_matrix=A_matrix^(-1)*b_matrix;
h33=(1/(sum(h_matrix.^2)+1))^0.5;h_matrix=h33*h_matrix;
homography_matrix=[h_matrix(1,1) h_matrix(2,1) h_matrix(3,1);h_matrix(4,1) h_matrix(5,1) h_matrix(6,1);h_matrix(7,1) h_matrix(8,1) h33];
h1_size=size(h1);h2_size=size(h2);
% result=zeros(h1_size(1),h1_size(2),h1_size(3));
H_T=projective2d(homography_matrix');
result=imwarp(h2,H_T);
figure(1)
imshow(result);title('Transformed im02');
size_result=size(result);
canvas=zeros(size_result(1),size_result(2),size_result(3));canvas_offset=350;
for x=1:size_result(2)
    for y=1:size_result(1)
        canvas(y,x+canvas_offset,:)=result(y,x,:);
    end
end
x_leftup=(homography_matrix(1,1)+homography_matrix(1,2)+homography_matrix(1,3))/(homography_matrix(3,1)+homography_matrix(3,2)+homography_matrix(3,3));
y_leftup=(homography_matrix(2,1)+homography_matrix(2,2)+homography_matrix(2,3))/(homography_matrix(3,1)+homography_matrix(3,2)+homography_matrix(3,3));
y_rightup=(homography_matrix(2,1)*h1_size(2)+homography_matrix(2,2)+homography_matrix(2,3))/(homography_matrix(3,1)*h1_size(2)+homography_matrix(3,2)+homography_matrix(3,3));
x_leftdown=(homography_matrix(2,1)+homography_matrix(2,2)*h1_size(1)+homography_matrix(2,3))/(homography_matrix(3,1)+homography_matrix(3,2)*h1_size(1)+homography_matrix(3,3));
x_offset=min(x_leftup,x_leftdown);y_offset=min(y_leftup,y_rightup);
for x=1:h1_size(2)
    for y=1:h1_size(1)
        if canvas(round(y-y_offset),round(x+canvas_offset-x_offset),:)>0
            canvas(round(y-y_offset),round(x+canvas_offset-x_offset),:)=canvas(round(y-y_offset),round(x+canvas_offset-x_offset),:)/2+h1(y,x,:)/2;
        else
            canvas(round(y-y_offset),round(x+canvas_offset-x_offset),:)=h1(y,x,:);
        end
    end
end
figure(2)
imshow(canvas);title('image after stitching');