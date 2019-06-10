close all;
clear all;
clc;
a=imread('ori.jpg');
%N(:,:,1)=histeq(a(:,:,1));
%N(:,:,2)=histeq(a(:,:,2));
%N(:,:,3)=histeq(a(:,:,3));
N(:,:,1)=histeq(a(:,:,1));
N(:,:,2)=histeq(a(:,:,2));
N(:,:,3)=histeq(a(:,:,3));
C(:,:,1)=adapthisteq(a(:,:,1));
C(:,:,2)=adapthisteq(a(:,:,2));
C(:,:,3)=adapthisteq(a(:,:,3));
figure();
imshow(N);
figure();
imshow(C);
newmean=mean2(N)
stdnew=std2(N)
N=double(N);
varnew=var(N(:))

anewmean=mean2(C)
astdnew=std2(C)
C=double(C);
avarnew=var(C(:))