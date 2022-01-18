clc;clear;close all;
% The folder 'vlfeat-0.9.21' should be added to path before running
run('vlfeat-0.9.21/toolbox/vl_setup.m')
img1 = imread('im01.jpg');
img2 = imread('im02.jpg');
[loc1,des1] = vl_sift(single(rgb2gray(img1))) ;
[loc2,des2] = vl_sift(single(rgb2gray(img2))) ;
allmatched=vl_ubcmatch(des1,des2,1.4);

allmatched_size=size(allmatched,2);
im01_loc=zeros(2,allmatched_size);im02_loc=zeros(2,allmatched_size);
for i=1:allmatched_size
    im01_loc(2,i)=loc1(1,allmatched(1,i));im01_loc(1,i)=loc1(2,allmatched(1,i));
    im02_loc(2,i)=loc2(1,allmatched(2,i));im02_loc(1,i)=loc2(2,allmatched(2,i));
end
drawMatch(img1,img2,im01_loc,im02_loc)
fprintf('Found %d matches.\n', allmatched_size);
epsilon=0.5;iteration=10000;I_best=0;times=0;k=0;
while k<iteration
    I_now=0;
    % use four pairs of random points to generate homography matrix
    randompick=randperm(allmatched_size,4);
    x1=[im01_loc(2,randompick(1)) im01_loc(2,randompick(2)) im01_loc(2,randompick(3)) im01_loc(2,randompick(4))];
    y1=[im01_loc(1,randompick(1)) im01_loc(1,randompick(2)) im01_loc(1,randompick(3)) im01_loc(1,randompick(4))];
    x2=[im02_loc(2,randompick(1)) im02_loc(2,randompick(2)) im02_loc(2,randompick(3)) im02_loc(2,randompick(4))];
    y2=[im02_loc(1,randompick(1)) im02_loc(1,randompick(2)) im02_loc(1,randompick(3)) im02_loc(1,randompick(4))];
    A_matrix=zeros(8);
    b_matrix=[x2(1);y2(1);x2(2);y2(2);x2(3);y2(3);x2(4);y2(4)];
    for i=1:4
        A_matrix(2*i-1:2*i,:)=[x1(i) y1(i) 1 0 0 0 -x2(i)*x1(i) -x2(i)*y1(i);0 0 0 x1(i) y1(i) 1 -y2(i)*x1(i) -y2(i)*y1(i)];
    end
    h_matrix=pinv(A_matrix)*b_matrix;
    h33=(1/(sum(h_matrix.^2)+1))^0.5;h_matrix=h33*h_matrix;
    homography_matrix=[h_matrix(1,1) h_matrix(2,1) h_matrix(3,1);h_matrix(4,1) h_matrix(5,1) h_matrix(6,1);h_matrix(7,1) h_matrix(8,1) h33];
    % caculate this homography matrix match how many points
    inliermatch=zeros(4,allmatched_size);count=1;
    for i=1:allmatched_size
        x=im01_loc(2,i);y=im01_loc(1,i);x2=im02_loc(2,i);y2=im02_loc(1,i);
        after_x=(homography_matrix(1,1)*x+homography_matrix(1,2)*y+homography_matrix(1,3))/(homography_matrix(3,1)*x+homography_matrix(3,2)*y+homography_matrix(3,3));
        after_y=(homography_matrix(2,1)*x+homography_matrix(2,2)*y+homography_matrix(2,3))/(homography_matrix(3,1)*x+homography_matrix(3,2)*y+homography_matrix(3,3));
        if (after_x-x2)^2+(after_y-y2)^2<epsilon
            I_now=I_now+1;inliermatch(:,count)=[y;x;y2;x2];count=count+1;
        end
    end
    % if this homography matrix perform better, update best homography matrix
    if I_now>I_best
        I_best=I_now;homography_matrix_best=homography_matrix;k=1;inliermatch_best=inliermatch;
    end
    k=k+1;times=times+1;
end
drawMatch(img1,img2,inliermatch_best(1:2,:),inliermatch_best(3:4,:))
fprintf('Found %d inlier matches.\n', I_best);
H_T=projective2d(homography_matrix_best');
result=imwarp(img1,H_T);

%caculate the offset on the canvas
im02_size=size(img2);im01_size=size(img1);result_size=size(result);
x_leftup=(homography_matrix_best(1,1)+homography_matrix_best(1,2)+homography_matrix_best(1,3))/(homography_matrix_best(3,1)+homography_matrix_best(3,2)+homography_matrix_best(3,3));
y_leftup=(homography_matrix_best(2,1)+homography_matrix_best(2,2)+homography_matrix_best(2,3))/(homography_matrix_best(3,1)+homography_matrix_best(3,2)+homography_matrix_best(3,3));
y_rightup=(homography_matrix_best(2,1)*im02_size(2)+homography_matrix_best(2,2)+homography_matrix_best(2,3))/(homography_matrix_best(3,1)*im02_size(2)+homography_matrix_best(3,2)+homography_matrix_best(3,3));
x_leftdown=(homography_matrix_best(1,1)+homography_matrix_best(1,2)*im02_size(1)+homography_matrix_best(1,3))/(homography_matrix_best(3,1)+homography_matrix_best(3,2)*im02_size(1)+homography_matrix_best(3,3));
x_offset=min(x_leftdown,x_leftup);y_offset=min(y_rightup,y_leftup);
canvas=im2uint8(zeros(2*im01_size(1)+2*result_size(1),2*im01_size(2)+2*result_size(2),3));
x_canvas=round((size(canvas,2)-result_size(2))/2);y_canvas=round((size(canvas,1)-result_size(1))/2);
% move first picture to the centre of the canvas
for y=1:result_size(1)
    for x=1:result_size(2)
        canvas(y+y_canvas,x+x_canvas,:)=result(y,x,:);
    end
end

% move second picture to the centre of the canvas(with offset)
for y=1:im02_size(1)
    for x=1:im02_size(2)
        x_real=round(x-x_offset+x_canvas);y_real=round(y-y_offset+y_canvas);
        if canvas(y_real,x_real,:)>0
            canvas(y_real,x_real,:)=canvas(y_real,x_real,:)/2+img2(y,x,:)/2;
        else
            canvas(y_real,x_real,:)=img2(y,x,:);
        end
    end
end

%cut black edges of the canvas
col_lower=1;row_lower=1;col_upper=size(canvas,2);row_upper=size(canvas,1);
while sum(sum(canvas(:,col_upper,:)))==0
    col_upper=col_upper-1;
end
while sum(sum(canvas(:,col_lower,:)))==0
    col_lower=col_lower+1;
end
while sum(sum(canvas(row_upper,:,:)))==0
    row_upper=row_upper-1;
end
while sum(sum(canvas(row_lower,:,:)))==0
    row_lower=row_lower+1;
end
final_canvas=canvas(row_lower-2:row_upper+2,col_lower-2:col_upper+2,:);
figure
imshow(final_canvas);