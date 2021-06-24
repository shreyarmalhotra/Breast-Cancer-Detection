clear all; 
close all;
a= imread('D:\db\4.jpg');
a= imresize(a,[512,512],'nearest')
%a= imread('C:\MATLAB7\work\u22.jpg');
%a= imread('32045.bmp');
%a=rgb2gray(a);
%a=rgb2gray(a);
%a=double(a);
[r,c]=size(a);
figure,imshow(a),title('original image');
%imwrite(a,'mdb209.tif');
% h= fspecial('log',[3 3], 0.5);
%h= fspecial('unsharp', 1);
%a=imfilter(a,h);
%%histogram equalization%%%%%
%s0=double(a);
%s1=imadjust(s0);
%a=uint8(s1);
%a1=bh(:)';
%v1=var(a1);
%figure,imshow(a),title('histogram equalised image');
%imwrite(bh,'HE.bmp');
% [r c]=size(bh);
% sum51=0;
% for a1=1:r
%     for b1=1:c
%            sum51(a1,b1)=((bh(a1,b1)-a(a1,b1))*(bh(a1,b1)-a(a1,b1)));% for HE
%     end
% end
%     f51=sum(sum51);
%     g51=sum(f51);
%     mse51=(g51/(r*c))%mean square error of HE image
%     psnr51=20*log(255/sqrt(mse51))%peak signal to noise ratio of HE imag
%     ss51=ssim(a,bh)%ss of original and Edge preserved HE

% unsharp masking
k=fspecial('unsharp',0.7);
un=imfilter(a,k);
%f1=uint8(f);
%a1=f1(:)';
%v2=var(a1);
figure,imshow(un);
title('unshrp masked image');
%imwrite(f1,'unsharp.bmp');
% [r c]=size(f1);
% sum51=0;
% for a1=1:r
%     for b1=1:c
%            sum51(a1,b1)=((f1(a1,b1)-a(a1,b1))*(f1(a1,b1)-a(a1,b1)));% for HE
%     end
% end
%     f51=sum(sum51);
%     g51=sum(f51);
%     mse51=(g51/(r*c))%mean square error of HE image
%     psnr51=20*log(255/sqrt(mse51))%peak signal to noise ratio of HE imag
%     ss51=ssim(a,f1)%ss of original and Edge preserved HE

k=fspecial('gaussian',[3 3],0.5);
f=imfilter(a,k);
%f1=uint8(f);
m11=min(min(f));
m1=max(max(f));
figure,imshow(f),title('lowpass filter');
%pixval on;


f2=a-f;
%f5=uint8(f2);
m12=min(min(f2));
m2=max(max(f2));
mid1=abs(m12+m2)/2;
figure,imshow(f2),title('highpass filter');
%pixval on;


[r,c]=size(f2);
g1=7;
g2=0.4;
for i=1:r
    for j=1:c
        if abs(f2(i,j))<mid1
            f2(i,j)=g1*f2(i,j);
        else if abs(f2(i,j))>=mid1
                f2(i,j)=g2*f2(i,j);
            end
        end
    end
end
figure,imshow(f2),title('highpss adaptation image');
%f2 = adapthisteq(f2,'clipLimit',0.03,'Distribution','rayleigh');
%se=strel('ball',30,17);
se=strel('disk',5);

%%% top hat by opening%%%%
b1=imerode(f,se);
%figure,imshow(b1),title('erosion');
b11=imdilate(b1,se);
%figure,imshow(b11),title('opening');
b=imsubtract(f,b11);
%figure,imshow(b),title('tophat by opening');

%%%%%bottom hat by closing%%%
b11=imdilate(f,se);
%figure,imshow(b11),title('dilution');
b1=imerode(b11,se);
%figure,imshow(b1),title('closing');
c=imsubtract(b1,f);
%figure,imshow(c),title('bottomhat by closing');
e=f+b-c;
%figure,imshow(e),title('tophat-bottomhat');
%d=f1+b-c;
figure,imshow(e),title('morphology enhanced image');

f6=f2+e;
figure,imshow(f6),title('contrast enhanced image');
%final2 = adapthisteq(f6,'clipLimit',0.03,'Distribution','rayleigh');
%figure,imshow(final2);
%title('final2 image');
%imwrite(f6,'morph_on_lpf.bmp');
display(PSNR(a,f6));
%%%%%%%%%%%%%wavelet decomposition%%%%%%%%%%%%%%
[c,s]=wavedec2(f6,2,'bior1.1');

ca2=appcoef2(c,s,'bior1.1',2);
ca1=appcoef2(c,s,'bior1.1',1);

[cH2,cV2,cD2]=detcoef2('all',c,s,2);
[cH1,cV1,cD1]=detcoef2('all',c,s,1);


%%%%%%%%%%%Thresholding Calculation%%%%%%%%%%

 
    MH=max(max(cH1));
    MH=log2(MH);
    MHL=0.5;
    TH=MH*MHL;
    
    
    MV=max(max(cV1));
     MV=log2(MV);
    MVL=0.5;
    TV=MV*MVL;
    
    MD=max(max(cD1));
     MD=log2(MD);
    MDL=0.5;
    TD=MD*MDL;
    
%     C1=2;
    MH2=max(max(cH2));
     MH2=log2(MH2);
    MHL2=1;
    TH2=MH2*MHL2;
    
    
    MV2=max(max(cV2));
     MV2=log2(MV2);
    MVL2=1;
    TV2=MV*MVL2;
    
    
    MD2=max(max(cD2));
     MD2=log2(MD2);
    MDL2=1;
    TD2=MD2*MDL2;
    
    
ch1 =wthresh(cH1,'s',TH);
cv1= wthresh(cV1,'s',TV);
cd1= wthresh(cD1,'s',TD);
ch2= wthresh(cH2,'s',TH2);
cv2= wthresh(cV2,'s',TV2);
cd2= wthresh(cD2,'s',TD2);


%%%%%%%%%%%%%%%reconstruction%%%%%%%%%%%%%%%

ca2=ca2(:)';
ch2=ch2(:)';
cv2=cv2(:)';
cd2=cd2(:)';
ch1=ch1(:)';
cv1=cv1(:)';
cd1=cd1(:)';
d=[ca2 ch2 cv2 cd2];
t=[ch1 cv1 cd1];
C=[d t];
b=waverec2(C,s,'bior1.1');
b=uint8(b);
figure,imshow(b);
title('final image');
final2 = adapthisteq(b,'clipLimit',0.01,'Distribution','exponential', 'Alpha', 0.2, 'NBins', 256);
figure,imshow(final2);
title('final2 image');

display(PSNR(a,b));
display(PSNR(a,final2));

%imwrite(final2,'morph_on_LPF.bmp');

% [r c]=size(b);
% sum51=0;
% for a1=1:r
%     for b1=1:c
%            sum51(a1,b1)=((b(a1,b1)-f6(a1,b1))*(b(a1,b1)-f6(a1,b1)));% for HE
%     end
% end
%     f51=sum(sum51);
%     g51=sum(f51);
%     mse51=(g51/(r*c))%mean square error of HE image
%     psnr51=20*log(255/sqrt(mse51))%peak signal to noise ratio of HE imag
%     ss51=ssim(a,b)%ss of original and Edge preserved HE
