close all;
clear all;
clc;
a=imread('cat1p.jpg');
a=imnoise(a,'salt & pepper',0.3);
figure;
imshow(a);
a1=double(a);
r=edge(a1,'sobel',25);
figure;
imshow(uint8(r));
[m,n]=size(a);
for p=1:m
    for q=1:n
        S=3;
        N(p,q)=adaptmed(a,p,q,S);
    end
end

figure;
imshow((N));
N=double(N);
u=edge(N,'sobel',25);
figure;
imshow(u);