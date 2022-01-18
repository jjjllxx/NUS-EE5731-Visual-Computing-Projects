function [I_best] = inlierNum(loc1,loc2,allmatched,epsilon)

allmatched_size=size(allmatched,2);
im01_loc=zeros(2,allmatched_size);im02_loc=zeros(2,allmatched_size);
for i=1:allmatched_size
    im01_loc(2,i)=loc1(1,allmatched(1,i));im01_loc(1,i)=loc1(2,allmatched(1,i));
    im02_loc(2,i)=loc2(1,allmatched(2,i));im02_loc(1,i)=loc2(2,allmatched(2,i));
end
iteration=2000;I_best=0;times=0;k=0;
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
        if (after_x-x2)^2+(after_y-y2)^2<epsilon && ~ismember(y2,inliermatch)
            I_now=I_now+1;inliermatch(:,count)=[y;x;y2;x2];count=count+1;
        end
    end
    % if this homography matrix perform better, update best homography matrix
    if I_now>I_best
        I_best=I_now;homography_matrix_best=homography_matrix;k=1;inliermatch_best=inliermatch;
    end
    k=k+1;times=times+1;
end
end

