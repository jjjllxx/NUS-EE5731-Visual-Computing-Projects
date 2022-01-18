function [] = drawMatch( img1, img2, loc1, loc2 )
rows1 = size(img1,1);
rows2 = size(img2,1);
if (rows1 < rows2)
     img1(rows2,1) = 0;
else
     img2(rows1,1) = 0;
end
img3 = [img1 img2];
figure('Position', [100 100 size(img3,2) size(img3,1)]);
imagesc(img3);
hold on;
cols1 = size(img1,2);
n = size(loc1,2);
colors = ['c','m','y'];
colors_n = length(colors);

for i = 1: n
    color = colors(randi(colors_n));
    line([loc1(2,i) loc2(2,i)+cols1],[loc1(1,i) loc2(1,i)], 'Color', color);
end
hold off;
end


