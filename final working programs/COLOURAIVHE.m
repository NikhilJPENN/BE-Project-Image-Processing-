
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% color images to see difference 
close all;
clear all;
clc;
a=imread('bone.jpg');

figure(1);
imshow(a);
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
% figure(2);
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
gamma=0.35;
beta=0.35;

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
%  figure(3);
%  bar(Pa);
%CALCULATION OF RUNNING SUM
C=zeros(1,l);
C(1)=Pa(1);        
for i=2:l
    C(i)=Pa(i)+C(i-1);
end;
for i=1:l  
f(i)=(l-1)*(C(i)/C(l-1));
end;
N(:,:,t)=f(a(:,:,t)+1);
end
figure(2);
imshow((N));


