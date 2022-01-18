clc;clear;close all;
% The folder 'vlfeat-0.9.21' should be added to path before running
run('vlfeat-0.9.21/toolbox/vl_setup')
tic
pic_num=5;
x=1:pic_num;
% disorder images ,make them imread in an unorder way
unorder=randsample(x,length(x));
for i=1:pic_num
    eval(['img' num2str(i) '= imread(''building' num2str(unorder(i)) '.jpg'')'])
end
for i=1:pic_num
    eval(['[loc' num2str(i) ',des' num2str(i) ']=vl_sift(single(rgb2gray(img' num2str(i) ')))'])
end

match_coeffcient=1.7;epsilon=3;
match_num=zeros(1,pic_num*(pic_num-1)/2);num=0;inlier_num=zeros(1,pic_num*(pic_num-1)/2);
index=zeros(2,pic_num*(pic_num-1)/2);
% calculate the match number and inlier match number of one image with all others
for i=1:pic_num-1
    for j=i+1:pic_num
        num=num+1;
        all_match=vl_ubcmatch(eval(['des' num2str(i)]),eval(['des' num2str(j)]),match_coeffcient);
        inlier_match=inlierNum(eval(['loc' num2str(i)]),eval(['loc' num2str(j)]),all_match,epsilon);
        match_num(1,num)=length(all_match(2,:));
        inlier_num(1,num)=inlier_match;
        index(1,num)=i;index(2,num)=j;
    end
end
% judge the link relationship
link=zeros(1,num);
for i=1:num
    if inlier_num(i)>match_num(i)*0.3+8
        link(i)=1;
    end
end
drawed=[];draw_times=0;flag=0;
% according to the relationship draw panoramic images
% using stitching direction switching method
while sum(link) && flag<2*num
    for i=1:num
        if link(i)
            if draw_times==0
                allmatched=vl_ubcmatch(eval(['des' num2str(index(1,i))]),eval(['des' num2str(index(2,i))]),match_coeffcient);
                loc01=eval(['loc' num2str(index(1,i))]);loc02=eval(['loc' num2str(index(2,i))]);
                img01=eval(['img' num2str(index(1,i))]);img02=eval(['img' num2str(index(2,i))]);
                canvas0 = ransac1(loc01,loc02,img01,img02,allmatched);
                draw_times=draw_times+1;drawed=[drawed index(1,i) index(2,i)];link(i)=0;flag=0;
            elseif ~ismember(index(1,i),drawed) && ismember(index(2,i),drawed)
                loc01=eval(['loc' num2str(index(1,i))]);img01=eval(['img' num2str(index(1,i))]);
                [loc02,des02]=vl_sift(single(rgb2gray(canvas0)));img02=canvas0;
                allmatched=vl_ubcmatch(eval(['des' num2str(index(1,i))]),des02,match_coeffcient);
                canvas0 = ransac2(loc01,loc02,img01,img02,allmatched);
                draw_times=draw_times+1;drawed=[drawed index(1,i)];link(i)=0;flag=0;
                
            elseif ~ismember(index(2,i),drawed) && ismember(index(1,i),drawed)
                loc01=eval(['loc' num2str(index(2,i))]);img01=eval(['img' num2str(index(2,i))]);
                [loc02,des02]=vl_sift(single(rgb2gray(canvas0)));img02=canvas0;
                allmatched=vl_ubcmatch(eval(['des' num2str(index(2,i))]),des02,match_coeffcient);
                canvas0 = ransac2(loc01,loc02,img01,img02,allmatched);
                draw_times=draw_times+1;drawed=[drawed index(2,i)];link(i)=0;flag=0;
            end
        end
    end
    flag=flag+1;
end
for i=1:pic_num
    if ~ismember(i,drawed)
        loc01=eval(['loc' num2str(i)]);img01=eval(['img' num2str(i)]);
        [loc02,des02]=vl_sift(single(rgb2gray(canvas0)));img02=canvas0;
        allmatched=vl_ubcmatch(eval(['des' num2str(i)]),des02,match_coeffcient);
        if mod(draw_times,2)
            canvas0 = ransac1(loc01,loc02,img01,img02,allmatched);
        else
            canvas0 = ransac1(loc01,loc02,img01,img02,allmatched);
        end
        drawed=[drawed i];draw_times=draw_times+1;
    end
end
toc