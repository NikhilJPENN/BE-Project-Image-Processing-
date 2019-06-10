close all;
clear all;
clc;
a=imread('ori.jpg');
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
% figure(3);
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
N(:,:,t)=f(a(:,:,t)+1);
end
figure(2);
imshow((N));
% NI=rgb2hsv(N);
% 
% E=edge(NI(:,:,3),'canny',0.23);
% figure(3);
% imshow(E);

% Ro=mean(mean(a(:,:,1)))
% % %Go=mean(mean(a(:,:,2)))
% % %Bo=mean(mean(a(:,:,3)))
% % 
% Rn=mean(mean(N(:,:,1)))
% % %Gn=mean(mean(N(:,:,2)))
% % %Bn=mean(mean(N(:,:,3)))
% % 
% Orig=mean(mean(mean(a)))
% New=mean(mean(mean(N)))
% % 
% a=double(a);
% N=double(N);
% % 
% Rso=std(std(a(:,:,1)))
% % Gso=std(std(a(:,:,2)))
% % Bvo=std(std(a(:,:,3)))
% % 
% Rsn=std(std(N(:,:,1)))
% % Gsn=std(std(N(:,:,2)))
% % Bsn=std(std(N(:,:,3)))
% % 
% Origs=std(std(mean(a)))
% News=std(std(mean(N)))
% % 
% % 
% Rvo=var(var(a(:,:,1)))
% % Gvo=var(var(a(:,:,2)))
% % Bvo=var(var(a(:,:,3)))
% % 
% Rvn=var(var(N(:,:,1)))
% % Gvn=var(var(N(:,:,2)))
% % Bvn=var(var(N(:,:,3)))
% % 
% Origv=var(var(mean(a)))
% Newv=var(var(mean(N)))

Origmean=mean2(a)
newmean=mean2(N)

stdorig=std2(a)
stdnew=std2(N)


 a=double(a);
N=double(N);
varorig=var(a(:))
varnew=var(N(:))