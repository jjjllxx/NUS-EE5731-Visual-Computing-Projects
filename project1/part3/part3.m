clc;clear;
h1=im2double(imread('h1.jpg'));h2=im2double(imread('h2.jpg'));
imagesc(h1);title('Choose 4 Homography Points')
[x1,y1]=ginput(4);
imagesc(h2);title('Choose 4 Homography Points.')
[x2,y2]=ginput(4);
close
%h1 to h2
A_matrix_1=zeros(8);
b_matrix_1=[x2(1);y2(1);x2(2);y2(2);x2(3);y2(3);x2(4);y2(4)];
for x=1:4
    A_matrix_1(2*x-1:2*x,:)=[x1(x) y1(x) 1 0 0 0 -x2(x)*x1(x) -x2(x)*y1(x);0 0 0 x1(x) y1(x) 1 -y2(x)*x1(x) -y2(x)*y1(x)];
end
h_matrix_1=A_matrix_1^(-1)*b_matrix_1;
h33_1=(1/(sum(h_matrix_1.^2)+1))^0.5;h_matrix_1=h33_1*h_matrix_1;
homography_matrix_1=[h_matrix_1(1,1) h_matrix_1(2,1) h_matrix_1(3,1);h_matrix_1(4,1) h_matrix_1(5,1) h_matrix_1(6,1);h_matrix_1(7,1) h_matrix_1(8,1) h33_1];
h1_size=size(h1);h2_size=size(h2);h2_after=zeros(h2_size(1),h2_size(2),h2_size(3));
for x=1:h1_size(2)
    for y=1:h1_size(1)
        after_x=(homography_matrix_1(1,1)*x+homography_matrix_1(1,2)*y+homography_matrix_1(1,3))/(homography_matrix_1(3,1)*x+homography_matrix_1(3,2)*y+homography_matrix_1(3,3));
        after_y=(homography_matrix_1(2,1)*x+homography_matrix_1(2,2)*y+homography_matrix_1(2,3))/(homography_matrix_1(3,1)*x+homography_matrix_1(3,2)*y+homography_matrix_1(3,3));
        if after_x>=1 && after_y>=1
            h2_after(int64(after_y),int64(after_x),:)=h1(y,x,:);
        end
    end
end
figure(1) 
imshow(im2uint8(h2_after));title('Transform h1 to h2');
%h2 to h1
A_matrix_2=zeros(8);
b_matrix_2=[x1(1);y1(1);x1(2);y1(2);x1(3);y1(3);x1(4);y1(4)];
for x=1:4
    A_matrix_2(2*x-1:2*x,:)=[x2(x) y2(x) 1 0 0 0 -x1(x)*x2(x) -x1(x)*y2(x);0 0 0 x2(x) y2(x) 1 -y1(x)*x2(x) -y1(x)*y2(x)];
end
h_matrix_2=A_matrix_2^(-1)*b_matrix_2;
h33_2=(1/(sum(h_matrix_2.^2)+1))^0.5;h_matrix_2=h33_2*h_matrix_2;
homography_matrix_2=[h_matrix_2(1,1) h_matrix_2(2,1) h_matrix_2(3,1);h_matrix_2(4,1) h_matrix_2(5,1) h_matrix_2(6,1);h_matrix_2(7,1) h_matrix_2(8,1) h33_2];
H_T=projective2d(homography_matrix_2');
result=imwarp(h2,H_T);
figure(2)
imshow(result);title('Transform h2 to h1');