close all;
clear all;
clc;
I1=imread('Fundus_retinoblastoma.jpg');
[m,n,o]=size(I1);

if (o==3)
    I1=rgb2gray(I1);
end

h1 = fspecial('gaussian',3);
I=imfilter(I1,h1);


%zero padding
Z=zeros(m+2,n+2);
for j=1:m
    for k=1:n
        Z(j+1,k+1)=I(j,k);
    end
end

px=zeros(m+1,n+1);
py=zeros(m+1,n+1);
M1=zeros(m+1,n+1);
M=zeros(m+1,n+1);
theta=zeros(m+1,n+1);
thetaz=zeros(m+1,n+1);
nms=zeros(m+1,n+1);
%finding gradient

for i=2:m+1
    for j=2:n+1
        px(i,j)=Z(i,j+1)-Z(i,j-1)+(Z(i-1,j+1)-Z(i-1,j-1)+Z(i+1,j+1)-Z(i+1,j-1))/2;
        py(i,j)=Z(i+1,j)-Z(i-1,j)+(Z(i+1,j-1)-Z(i-1,j-1)+Z(i+1,j+1)-Z(i-1,j-1))/2;
        M1(i,j)=((px(i,j))^2+(py(i,j))^2);
        theta(i,j)=atand(py(i,j)/px(i,j));
    end
end




M1=sqrt(M1);

minimum=min(min(M1));
M1=M1-minimum;
% M=M1;
MAX=max(max(M1));
M=M1/MAX;




%M=M1/MAX;

%M=double(M);


figure(1);
imshow(I);
title('original image');
figure(2);
imshow((M));
title('gradient image');
figure(3);
imhist(M,256);
title('histogram of gradient image');
H=imhist(M,256);
theta;

for i=1:m+1
    for j=1:n+1
        if (theta(i,j)<0)
            thetaz(i,j)=360+theta(i,j);
        else
            thetaz(i,j)=theta(i,j);
            
        end
    end
end

for i=1:m+1
    for j=1:n+1
          if ((thetaz(i,j)>0 && thetaz(i,j)<=22.5) || (thetaz(i,j)>157.5 && thetaz(i,j)<=202.5) || (thetaz(i,j)>337.5 && thetaz(i,j)<360))
            thetaz(i,j)=0;
          elseif ((thetaz(i,j)>22.5 && thetaz(i,j)<=67.5) || (thetaz(i,j)>202.5 && thetaz(i,j)<=247.5))
              thetaz(i,j)=1;
          elseif ((thetaz(i,j)>67.5 && thetaz(i,j)<=112.5) || (thetaz(i,j)>247.5 && thetaz(i,j)<=292.5))
              thetaz(i,j)=2;
          else thetaz(i,j)=3;
          end
    end
end

thetaz;

for i=2:m
    for j=2:n
        if (thetaz(i,j)==0)
            if(M(i,j-1)>M(i,j) || M(i,j+1)>M(i,j))
                nms(i,j)=0;
            else
                nms(i,j)=M(i,j);
            end
        elseif (thetaz(i,j)==1)
            if(M(i-1,j-1)>M(i,j) || M(i+1,j+1)>M(i,j))
                nms(i,j)=0;
            else
                nms(i,j)=M(i,j);
            end
        elseif (thetaz(i,j)==2)
            if(M(i-1,j)>M(i,j) || M(i+1,j)>M(i,j))
                nms(i,j)=0;
            else
                nms(i,j)=M(i,j);
            end
        else
            if(M(i+1,j-1)>M(i,j) || M(i-1,j+1)>M(i,j))
                nms(i,j)=0;
            else
                nms(i,j)=M(i,j);
            end
        end
    end
end




figure(4);
imshow((nms));
title('non maxima suppressed image');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% t=graythresh(I);
% L=max(max(I));
% L=double(L);
% u=(log(L))/(log(2))
% u=ceil(u);
% L1=power(2,u);
% l=L1;
% b=zeros(1,l);
% for k=0:(l-1)
%     for i=1:m
%         for j=1:n
%             if I(i,j)==k
%                b(k+1)=b(k+1)+1;
%             end
%         end
%     end
% end
% for i=1:l
%     p(i)=b(i)/(m*n);
% end
% w0=0;
% for i=1/l:1/l:(t)
%     w0=w0+p(round(i*l));
% end
% 
% w1=1-w0;
% 
% u0=0;
% for i=1/l:1/l:(t)
%     u0=u0+(i*p(round(i*l)));
% end
%    u0=u0/w0;
%    u1=0;
%    for i=t:1/l:1
%     u1=u1+(i*p(round(i*l)));
%    end
%     u1=u1/w1;
%     
%   sigma0=0;
%   for i=1/l:1/l:(t)
%       sigma0=sigma0+(((i-u0)^2)*p(round(i*l)));
%   end
%   sigma0=sigma0/w0;
%   
%   sigma1=0;
%   for i=t:1/l:1
%       sigma1=sigma1+(((i-u1)^2)*p(round(i*l)));
%     end
%   sigma1=sigma1/w1;  
%   
%   uT=0;
%   for i=1/l:1/l:1
%       uT=uT+(i*p(round(i*l)));
%   end
%   
%   sigmaT=0;
%    for i=1/l:1/l:1
%       sigmaT=sigmaT+(((i-uT)^2)*p(round(i*l)));
%    end
% 
%   sigmaB=w0*((u0-uT)^2)+w1*((u1-uT)^2);
%   sigmaBCD=w0*w1*((u0-u1)^2);                    %%%%%%%%%%%%%
%   
%   sigmaW=w0*sigma0+w1*sigma1;
%   
%   uT2=w0*u0+w1*u1;             %%%%%%
%   sigmaT2=sigmaB+sigmaW;         %%%%%%
%   
%   lambda=sigmaB/sigmaW;
%   kk=sigmaT/sigmaW;
%   eta=sigmaB/sigmaT;
%   
%   
%   Th=u0+sqrt(sigma0)
%   Tl=u0-0.3*sqrt(sigma0)
Th=0.05;
Tl=0.01;
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%EDE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%LINKING
Gnh=zeros(m+1,n+1);
Gnl=zeros(m+1,n+1);
gnl=zeros(m+1,n+1);




for i=1:m+1
    for j=1:n+1
        if (nms(i,j)>Th)
            Gnh(i,j)=nms(i,j);
        end
    end
end

for i=1:m+1
    for j=1:n+1
        if (nms(i,j)>Tl)
            gnl(i,j)=nms(i,j);
        end
    end
end

Gnl=gnl-Gnh;


figure(5);
imshow((Gnh));
title('high threshold image');
figure(6);
imshow((Gnl));
title('low threshold image');

N=zeros(m+1,n+1);

for i=2:m
    for j=2:n
        if (Gnh(i,j)~=0)
            N(i,j)=1;
        end
        if (N(i,j)==1)
            if (Gnl(i-1,j-1)~=0)
                N(i-1,j-1)=1;
            end
            if (Gnl(i-1,j)~=0)
                N(i-1,j)=1;
            end
            if (Gnl(i-1,j+1)~=0)
                N(i-1,j+1)=1;
            end
            if (Gnl(i,j-1)~=0)
                N(i,j-1)=1;
            end
            if (Gnl(i,j+1)~=0)
                N(i,j+1)=1;
            end
            if (Gnl(i+1,j-1)~=0)
                N(i+1,j-1)=1;
            end
            if (Gnl(i+1,j)~=0)
                N(i+1,j)=1;
            end
            if (Gnl(i+1,j+1)~=0)
                N(i+1,j+1)=1;
            end
        end
    end
end

figure(7);
imshow((N));
title('canny output');

C=edge(I,'canny');
figure(8);
imshow(C);
