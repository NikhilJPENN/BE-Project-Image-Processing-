close all;
clear all;
clc;
a=imread('tifimpulselena.tif');
a=imnoise(a,'salt & pepper',0.4);
figure(1);
imshow(a);
Smax=9;
flag=0;


sz=3;
[m,n]=size(a);

Z=zeros(m+(sz-1),n+(sz-1));
N=zeros(m,n);
for j=1:m
    for k=1:n
        Z(j+(sz-2),k+(sz-2))=a(j,k);
    end
end
x=sz;
y=sz;
      for p=1:m
        for q=1:n
            for i=1:x
               for j=1:y
                   c(i,j)=z(i+p-1,j+q-1);
               end
            end
            t=reshape(c,1,x*y);
            t1=sort(t);
            Zmed=median(t1);
            Zmin=min(min(c));
            Zmax=max(max(c));
            
            A1=Zmed-Zmin;
            A2=Zmed-Zmax;
            if A1>0 && A2<0
                B1=a(p,q)-Zmin;
                B2=a(p,q)-Zmax;
                if B1>0 && B2<0
                    N(p,q)=a(p,q);
                else
                    N(p,q)=Zmed;
                end;
            else
                sz=sz+2;
                if sz<=Smax
                    
                else
                    flag=0;
                    N(p,q)=Zmed;
                end;
            end;
        end;
    end;

            
figure(2);
imshow(N);