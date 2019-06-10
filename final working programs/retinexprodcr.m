clc;
close all;
clear all;
I=imread('fireman.jpg');
[m n o]=size(I);
%if(o==3)
hsi=rgb2hsv(I);
%end
K=1;
std1=5;
std2=25;
std3=240;



for i=1:m
    for j=1:n
       I_sum(i,j)=(I(i,j,1)+I(i,j,2)+I(i,j,3));
    end
end

I_sum=double(I_sum);
I=double(I);
for x=1:m
    for y=1:n
Ifun(x,y,1)=(I(x,y,1))/(I_sum(x,y));
Ifun(x,y,2)=(I(x,y,2))/(I_sum(x,y));
Ifun(x,y,3)=(I(x,y,3))/(I_sum(x,y));
    end
end
Ifun=double(Ifun);
%c=log(Ifun);
 Gf=5
 Of=10
c=Gf*log(Ifun-Of);%%%%%%
% % beta=6;
% alpha=5;
% c=beta*log(alpha*Ifun);

%c=5*(Ifun).^(0.2); %%%%%%%%%% working 0.2 ans 5 times
%c=exp(1/Ifun);      %%%%%%%%%% working

% figure
% imshow(uint8(c));
% title('Powerlaw transformed image');
 c=double(c);

% for i=1:m
%     for j=1:n
%       c(i,j,1)=(Ifun(i,j,1))^3;
%       c(i,j,2)=(Ifun(i,j,2))^3;
%       c(i,j,3)=(Ifun(i,j,3))^3;
%       
%     end
% end


% R=retinex_MSR(hsi(:,:,3),K,std1,std2,std3);
R(:,:,1)=retinex_MSR2(I(:,:,1),K,std1,std2,std3);
R(:,:,2)=retinex_MSR2(I(:,:,2),K,std1,std2,std3);
R(:,:,3)=retinex_MSR2(I(:,:,3),K,std1,std2,std3);

% [R1(:,:,1),R2(:,:,1),R3(:,:,1)]=retinex_MSR(I(:,:,1),K,std1,std2,std3);
% [R1(:,:,2),R2(:,:,2),R3(:,:,2)]=retinex_MSR(I(:,:,2),K,std1,std2,std3);
% [R1(:,:,3),R2(:,:,3),R3(:,:,3)]=retinex_MSR(I(:,:,3),K,std1,std2,std3);

figure;
imshow(uint8(I));
title('original image');
figure;
imshow((R));
title('retinex before colour restoration');
% N(:,:,3)=R(:,:,3);
% N(:,:,2)=R(:,:,2);
% N(:,:,1)=R(:,:,1);
%new=hsv2rgb(N);

% figure;
% imshow(R1);
% title('std1');
% 
% figure;
% imshow(R2);
% title('std2');
% 
% figure;
% imshow(R3);
% title('std3');
% 
% R=(R1+R2+R3)/3;
reti(:,:,1)=c(:,:,1).*R(:,:,1);
reti(:,:,2)=c(:,:,2).*R(:,:,2);
reti(:,:,3)=c(:,:,3).*R(:,:,3);

figure;
imshow(reti);
title('after colour restoration');

%%% Gain/Offset correction
% GOC(:,:,1)= (255/(max(max(I(:,:,1)))-min(min(I(:,:,1))))).*(reti(:,:,1)-min(min(I(:,:,1))));
% GOC(:,:,2)= (255/(max(max(I(:,:,2)))-min(min(I(:,:,2))))).*(reti(:,:,2)-min(min(I(:,:,2))));
% GOC(:,:,3)= (255/(max(max(I(:,:,3)))-min(min(I(:,:,3))))).*(reti(:,:,3)-min(min(I(:,:,3))));
%%%%%%%%%%%%%%%%%%%%%%%
E=0.5;
U=-0.6;
GOC(:,:,1)= E*(reti(:,:,1)+U);
GOC(:,:,2)= E*(reti(:,:,2)+U);
GOC(:,:,3)= E*(reti(:,:,3)+U);
Iout=GOC;
% % offset=mean(mean((reti)));
% % 
% % div=std(std(reti));
% % alpha=2;
% % 
% % for i=1:3
% % fmin(:,:,i)=offset(:,:,i)-alpha*div(:,:,i);
% % fmax(:,:,i)=offset(:,:,i)+alpha*div(:,:,i);
% % end
% % 
% % for i=1:3
% % for x=1:m
% %     for y=1:n
% %         Iout(x,y,i)=((reti(x,y,i))-offset(i)+fmin(i))/(fmax(i)-offset(i)+fmin(i));
% %     end
% % end
% % end
% 
figure
imshow(uint8(Iout));
% 
% 

