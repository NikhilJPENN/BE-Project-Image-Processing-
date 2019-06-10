%%%%%%%%%%%%%%%%%%%%%  gray scale images and histograms to see difference

%while('ch==1')
close all;
clear all;
clc;
beta=input('Enter value of Beta:')
gamma=input('Enter value of gamma:')
a=imread('retinal3.jpg');
a=rgb2gray(a);
I=a;
%a5=double(a5);
%  a=rgb2gray(a5);

figure;
imshow(a);
title('original image');
figure;
imhist(a);
title('original Histo image');
 hgram=[1:256];
 a2=histeq(a,hgram);
 figure;
 imshow(a2);
title('trad he image');
figure;
imhist(a2);

a3=adapthisteq(a);
figure;
imshow(a3);
title('clahe');
figure;
imhist(a3);

[m,n,q]=size(a);
for t=1:q
 l=max(max(a(:,:,t)))+1;
%l=length(a)
[m,n]=size(a(:,:,t));


%NO OF PIXELS HAVING INTENSITY k
b=zeros(1,l);
for k=1:l
    for i=1:m
        for j=1:n
            if a(i,j,t)==k
                b(k)=b(k)+1;
            end;
        end;
    end;
end;
b;

%CONVENTIONAL HISTOGRAM EQUALIZATION
%CALCULATION OF PDF
p=zeros(1,l);
for i=1:l
    p(i)=b(i)/(m*n);     %calc of pdf
end;
% figure;
% bar(p);

% %calculation of running sum
% s=zeros(1,l);
% s(1)=p(1);        
% for i=2:l
%     s(i)=p(i)+s(i-1);
% end;
% c=s(a)*l;
% c=ceil(c);
% imwrite(c,'newman.tif');
% l=length(c);
% [m,n]=size(c);
% b=zeros(1,l);
% for k=1:l
%     for i=1:m
%         for j=1:n
%             if c(i,j)==k
%                 b(k)=b(k)+1;
%             end;
%         end;
%     end;
% end;
% p=zeros(1,l);
% for i=1:l
%     p(i)=b(i)/(m*n);
% end;
% p;
% figure(3);
% bar(p);
% figure(4);
% imshow(uint8(c));
% 
% %END OF CONVENTIONAL HISTOGRAM EQUALIZATION

%AIVHE
Pbas=mean(p);
Ph=2*Pbas;
Xm1=mean(a(:,:,t));
Xm=mean(Xm1);
Xm=ceil(Xm);
% gamma=0.35;
% beta=0.35;

%CALCULATION OF ALPHA
alpha=zeros(1,l);
for k=1:Xm
    alpha(k)=((1-((Xm-k)/Xm))^2)*(1-gamma)+gamma;
end;
for k=Xm+1:l
    alpha(k)=((1-((k-Xm)/((l-1)-Xm)))^2)*(1-gamma)+gamma;
end;

%CALCULATION OF Paivhe
for k=1:l
    if p(k)>=Ph
        Pa(k)=Ph;
    end;
    if (p(k)<Ph && p(k)>Pbas)
        Pa(k)=p(k)-(alpha(k)*(p(k)-Pbas)*beta);
    end;
    if p(k)<=Pbas
        Pa(k)=p(k)+(alpha(k)*(Pbas-p(k))*beta);
    end;
end;
% figure;
% bar(Pa);
%CALCULATION OF RUNNING SUM
C=zeros(1,l);
C(1)=Pa(1);        
for i=2:l
    C(i)=Pa(i)+C(i-1);
end;
for i=1:l  
f(i)=(l-1)*(C(i)/C(l-1));
end;
%figure
%plot(f)
N(:,:,t)=f(a(:,:,t)+1);
end
figure;
imshow((N));
figure
imhist(N);

% % figure;
% % imhist(N);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% disp('Mean and Std deviation of Original Image')
% b=sum(sum(a));
% mean=(b/(m*n))
% 
% for i=1:m
%     for j=1:n
%         x(i,j)=(a(i,j)-mean)^2;
%     end;
% end;
% s=sum(sum(x));
% s=s/(m*n);
% sigma=sqrt(s)
% variance=(sigma)^2
% 
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
% 
% 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % disp('Mean and Std deviation of Original Image')
% % m1=mean(mean(I))
% % sigma1=std(std(I))
% % disp('Mean and Std deviation of Traditional HE Image')
% % m2=mean(mean(a2))
% % sigma2=std(std(a2))
% % disp('Mean and Std deviation of CLAHE Image')
% % m3=mean(mean(a3))
% % sigma3=std(std(a3))
% % disp('Mean and Std deviation of AIVHE Image')
% % m4=mean(mean(N))
% % sigma4=std(std(N))
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% 
% % BW = edge(N);
% % BW = edge(N,'canny');
% % figure;
% % imshow(BW);
% % title('canny on aivhe');
% % BW1=edge(a,'canny');
% % figure;
% % imshow(BW1);
% % title('canny on original');
% % %end
% % BW2=edge(a2,'canny');
% % figure;
% % imshow(BW2);
% % title('canny on trad he');
% % BW3=edge(a3,'canny');
% % figure;
% % imshow(BW3);
% % title('canny on clahe');
% 
% % BW = edge(N,'log');
% % figure;
% % imshow(BW);
% % title('log on aivhe');
% % BW1=edge(a,'log');
% % figure;
% % imshow(BW1);
% % title('log on original');
% % %end
% % BW2=edge(a2,'log');
% % figure;
% % imshow(BW2);
% % title('log on trad he');
% % BW3=edge(a3,'log');
% %  figure;
% %  imshow(BW3);
% % title('log on clahe');
% 
% % title('sobel on clahe');
% % BW = edge(N,'sobel',.01,'horizontal');
% % figure;
% % imshow(BW);
% % title('sobel on aivhe');
% % BW1=edge(a,'sobel',.01,'horizontal');
% % figure;
% % imshow(BW1);
% % title('sobel on original');
% % %end
% % BW2=edge(a2,'sobel',.01,'horizontal');
% % figure;
% % imshow(BW2);
% % title('sobel on trad he');
% % BW3=edge(a3,'sobel',.01,'horizontal');
% % figure;
% % imshow(BW3);
% % title('sobel on clahe');