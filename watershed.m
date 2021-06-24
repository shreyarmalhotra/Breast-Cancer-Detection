close all;
rgb = imread('D:\IP\Database\watr.png');
I = rgb2gray(rgb);
imshow(I);
gmag = imgradient(I);
figure,imshow(gmag,[]);
title('Gradient Magnitude');
se = strel('disk',20);
Io = imopen(I,se);
figure,imshow(Io);
title('Opening');
Ie = imerode(I,se);
Iobr = imreconstruct(Ie,I);
figure,imshow(Iobr);
title('Opening-by-Reconstruction')
Ioc = imclose(Io,se);
figure,imshow(Ioc)
title('Opening-Closing')
Iobrd = imdilate(Iobr,se);
Iobrcbr = imreconstruct(imcomplement(Iobrd),imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);
imshow(Iobrcbr)
title('Opening-Closing by Reconstruction')
fgm = imregionalmax(Iobrcbr);
figure,imshow(fgm)
title('Regional Maxima of Opening-Closing by Reconstruction')
I2 = labeloverlay(I,fgm);
figure,imshow(I2)
title('Regional Maxima Superimposed on Original Image')
se2 = strel(ones(5,5));
fgm2 = imclose(fgm,se2);
fgm3 = imerode(fgm2,se2);
fgm4 = bwareaopen(fgm3,20);
I3 = labeloverlay(I,fgm4);
imshow(I3)
title('Modified Regional Maxima Superimposed on Original Image')
fgm4 = bwareaopen(fgm3,20);
I3 = labeloverlay(I,fgm4);
figure,imshow(I3)
title('Modified Regional Maxima Superimposed on Original Image')
D = bwdist(bw);
DL = watershed(D);
bgm = DL == 0;
figure,imshow(bgm)
title('Watershed Ridge Lines)')