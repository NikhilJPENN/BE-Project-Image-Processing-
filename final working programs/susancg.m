clc;
close all;
clear all;
I=imread('rasta.jpg');
figure(1);
imshow(I);
title('original image');
[m,n,o]=size(I);
if (o==3)
I=rgb2gray(I);
end
% I=double(I);
a=edge(I,'canny',0.05);
figure(2);
imshow(a);
title('canny output');
%I=[2 4 3 4;54 3 32 34; 5 2 4 4;4 5 5 5];

mask=[0 0 1 1 1 0 0;0 1 1 1 1 1 0;1 1 1 1 1 1 1;1 1 1 1 1 1 1;1 1 1 1 1 1 1;0 1 1 1 1 1 0;0 0 1 1 1 0 0];

%%ZERO PADDING
Z1=zeros(m+2,n+2);
for j=1:m
    for k=1:n
        Z1(j+1,k+1)=I(j,k);
    end
end

[m,n]=size(Z1);
Z2=zeros(m+2,n+2);

for j=1:m
    for k=1:n
        Z2(j+1,k+1)=Z1(j,k);
    end
end

[m,n]=size(Z2);
Z=zeros(m+2,n+2);

for j=1:m
    for k=1:n
        Z(j+1,k+1)=Z2(j,k);
    end
end

[m,n]=size(I);
[x,y]=size(mask);
c1=zeros(x,y);
C=zeros(x,y);
N=zeros(m,n);
t=25;
count=zeros(m,n);
%t=thselect(I,'sqtwolog')
% APPLYING MASK

[l,b]=size(Z);

for p=1:m
    for q=1:n
        for i=1:x
           for j=1:y 
              c1(i,j)=mask(i,j)*Z(i+p-1,j+q-1);
          end
        end
        for g=1:x
            yl=0;
            for h=1:y 
             if((c1(g,h)-c1(4,4))<=t)
                  C(g,h)=255;
                  count(p,q)=count(p,q)+1;
              else
                  C(g,h)=0;
             end
           end
        end
        
        
        for s=1:x
             yl=0;
             secyl=0;
             for r=1:y
                 yl=yl+(r+q-1)*C(s,r);
                 secyl=secyl+(((r-1)^2)*C(s,r));
             end
                 YL(s)=yl;
                 SECYL(s)=secyl;
         end
         
         for a=1:x
             xl=0;
             secxl=0;
             gradsign1=0;
             for b=1:y
                 xl=xl+(b+p-1)*C(b,a); 
                 secxl=secxl+(((b-1)^2)*C(b,a));
                 gradsign1=gradsign1+(a-1)*(b-1)*C(b,a); 
                                 
             end
                 XL(a)=xl;
                 SECXL(a)=secxl;
                 gradsign(a)=gradsign1;
         end
         %gradsign
         % for 1st condition
         C(4,4)=c1(4,4);
         N(p,q)=sum(sum(C));
         Cgx(p,q)=(sum(XL)/N(p,q));
         Cgy(p,q)=(sum(YL)/N(p,q));
         GDS(p,q)=sum(gradsign);
         % for 2nd condition
           secmontx=sum(SECXL);
           secmonty=sum(SECYL);
         %--
         
         diffx=Cgx(p,q)-p;
         diffy=Cgy(p,q)-q;
         
         if ((count(p,q)>7) & ((diffx>1)& (diffy)>1))
%              orientx(p,q)=diffx;
%              orienty(p,q)=diffy;
             theta(p,q)=atand(diffy/diffx);
         else
              %theta(p,q)=atand(secmonty/secmontx);
             orient(p,q)=(secmontx/secmonty);
             theta(p,q)=orient(p,q);
         end
         
         
         C(4,4)=255;
         N(p,q)=sum(sum(C));
    end
end
 %theta
 GDS;
N;
count;
Nm=max(max(N));
G=(3*Nm)/4;
G=round(G);
R=zeros(m,n);
for i=1:m
    for j=1:n
        if N(i,j)<G
           R(i,j)=(G-N(i,j));
        else 
           R(i,j)=0; 
        end
    end
end

figure(3);
imshow(uint8(I));
title('gray of original');
figure(4);
imshow((R));
title('susan');
% R;
R=R-min(min(R));
R=R/max(max(R));
R=R*255;
%S=imclearborder(R);
%figure;
%imshow(S);
%R=R/23.8;
R=round(R);
%NON MAXIMA SUPPRESSION

for i=1:m
    for j=1:n
        if (theta(i,j)<0)
            thetaz(i,j)=360+theta(i,j);
        else
            thetaz(i,j)=theta(i,j);
            
        end
    end
end

for i=1:m
    for j=1:n
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

for i=2:m-1
    for j=2:n-1
        if (thetaz(i,j)==0)
            if(R(i,j-1)>R(i,j) || R(i,j+1)>R(i,j))
                nms(i,j)=0;
            else
                nms(i,j)=R(i,j);
            end
        elseif (thetaz(i,j)==1)
            if(R(i-1,j-1)>R(i,j) || R(i+1,j+1)>R(i,j))
                nms(i,j)=0;
            else
                nms(i,j)=R(i,j);
            end
        elseif (thetaz(i,j)==2)
            if(R(i-1,j)>R(i,j) || R(i+1,j)>R(i,j))
                nms(i,j)=0;
            else
                nms(i,j)=R(i,j);
            end
        else
            if(R(i+1,j-1)>R(i,j) || R(i-1,j+1)>R(i,j))
                nms(i,j)=0;
            else
                nms(i,j)=R(i,j);
            end
        end
    end
end
           

%nms=(nms);
%END OF NON MAXIMA SUPPRESSION

figure(5);
imshow(uint8(nms));
title('non maxima suppressed');

% EDGE LINKING

t=graythresh(I);
L=max(max(I));
L=double(L);
u=(log(L))/(log(2));
u=ceil(u);
L1=power(2,u);
l=L1;
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
%   end
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
  

Th=30;
Tl=20;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%EDE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%LINKING
Gnh=zeros(m+1,n+1);
Gnl=zeros(m+1,n+1);
gnl=zeros(m+1,n+1);




for i=1:m-1
    for j=1:n-1
        if (nms(i,j)>Th)
            Gnh(i,j)=nms(i,j);
        end
    end
end

for i=1:m-1
    for j=1:n-1
        if (nms(i,j)>Tl)
            gnl(i,j)=nms(i,j);
        end
    end
end

Gnl=gnl-Gnh;


figure(6);
imshow((Gnh));
title('high threshold image');
figure(7);
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

figure(8);
imshow((N));
title('susan after edge linking');