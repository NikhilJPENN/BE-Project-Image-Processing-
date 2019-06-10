clc;
close all;
clear all;
I=imread('firemanretinex.jpg');
figure
imshow(I);
disp('Mean and Std deviation of Original Image')
for i=1:3
    a=I(:,:,i);
    [m,n]=size(a);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

b=sum(sum(a));
mea(i)=(b/(m*n));

for p=1:m
    for q=1:n
        x(p,q)=(a(p,q)-mea(i))^2;
    end;
end;
s=sum(sum(x));
s=s/(m*n);
sigma(i)=sqrt(s);
variance(i)=(sigma(i))^2;
end
mean1=(sum(mea))/3
sigma1=(sum(sigma))/3
var1=(sum(variance))/3
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% disp('Mean and Std deviation of Traditional HE Image')
% b=sum(sum(a2));
% mean=(b/(m*n))
% 
% for i=1:m
%     for j=1:n
%         x(i,j)=(a2(i,j)-mean)^2;
%     end;
% end;
% s=sum(sum(x));
% s=s/(m*n);
% sigma=sqrt(s)
% variance=(sigma)^2
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% disp('Mean and Std deviation of CLAHE Image')
% b=sum(sum(a3));
% mean=(b/(m*n))
% 
% for i=1:m
%     for j=1:n
%         x(i,j)=(a3(i,j)-mean)^2;
%     end;
% end;
% s=sum(sum(x));
% s=s/(m*n);
% sigma=sqrt(s)
% variance=(sigma)^2
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% disp('Mean and Std deviation of AIVHE Image')
% b=sum(sum(N));
% mean=(b/(m*n))
% 
% for i=1:m
%     for j=1:n
%         x(i,j)=(N(i,j)-mean)^2;
%     end;
% end;
% s=sum(sum(x));
% s=s/(m*n);
% sigma=sqrt(s)
% variance=(sigma)^2
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
