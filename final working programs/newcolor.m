close all;
clear all;
clc;
a=imread('bone.jpg');
% a=rgb2gray(a);
figure;
imshow(a);
N(:,:,1)=adapthisteq(a(:,:,1));
N(:,:,2)=adapthisteq(a(:,:,2));
N(:,:,3)=adapthisteq(a(:,:,3));
figure;
imshow(N);
M(:,:,1)=histeq(a(:,:,1));
M(:,:,2)=histeq(a(:,:,2));
M(:,:,3)=histeq(a(:,:,3));
figure;
imshow(M);

% b=rgb2hsv(a);
% c(:,:,3)=histeq((b(:,:,3)));
% c(:,:,1)=b(:,:,1);
% c(:,:,2)=b(:,:,2);
% 
% d=hsv2rgb(c);
% figure;
% imshow(d);
