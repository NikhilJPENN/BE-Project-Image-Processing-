function R = retinex_MSR2(image, K, std1,std2,std3)
%function [R1,R2,R3] = retinex_MSR(image, K, std1,std2,std3)

if (exist('K', 'var') == 0) %Checks for existence of K:
default = 1
    K = 1;
end

if (exist('std1','var') == 0) %Checks for existence of     standard deviation: 
    default = 5;
end
if (exist('std2','var') == 0) %Checks for existence of     standard deviation: 
    default = 5;
end
if (exist('std3','var') == 0) %Checks for existence of     standard deviation: 
    default = 5;
end
image = double(image);
[n m] = size(image);

f1 = zeros(n,m); %Initializes Gaussian surround function f
% for i = 1:n %Creates surround function
%     y = i-n/2;
%     for j = 1:m
%         x = j-m/2;
%         f1(i,j) = exp(-(x*x + y*y)/(std1*std1)); 
%     end
% end

for i = 1:n %Creates surround function
    for j = 1:m
        f1(i,j) = exp(-(i*i + j*j)/(std1*std1)); 
    end
end

% f2 = zeros(n,m); %Initializes Gaussian surround function f
% for i = 1:n %Creates surround function
%     y = i-n/2;
%     for j = 1:m
%         x = j-m/2;
%         f2(i,j) = exp(-(x*x + y*y)/(std2*std2)); 
%     end
% end

f2 = zeros(n,m); %Initializes Gaussian surround function f
for i = 1:n %Creates surround function
      for j = 1:m
          f2(i,j) = exp(-(i*i + j*j)/(std2*std2)); 
      end
end

% f3 = zeros(n,m); %Initializes Gaussian surround function f
% for i = 1:n %Creates surround function
%     y = i-n/2;
%     for j = 1:m
%         x = j-m/2;
%         f3(i,j) = exp(-(x*x + y*y)/(std3*std3)); 
%     end
% end

f3 = zeros(n,m); %Initializes Gaussian surround function f
for i = 1:n %Creates surround function
   
    for j = 1:m
        f3(i,j) = exp(-(i*i + j*j)/(std3*std3)); 
    end
end

f1_sum = sum(f1(:)); %Sums surround function elements
f1 = f1/f1_sum; %Normalizes surround function

f2_sum = sum(f2(:)); %Sums surround function elements
f2 = f2/f2_sum; %Normalizes surround function

f3_sum = sum(f3(:)); %Sums surround function elements
f3 = f3/f3_sum; %Normalizes surround function

R = (1/K)*((log(image)-log(ifft2(fft2(f1).*fft2(image))))+(log(image)-log(ifft2(fft2(f2).*fft2(image))))+(log(image)-log(ifft2(fft2(f3).*fft2(image))))); 
% R1=log(image)-log(ifft2(fft2(f1).*fft2(image)));
% R2=log(image)-log(ifft2(fft2(f2).*fft2(image)));
% R3=log(image)-log(ifft2(fft2(f3).*fft2(image)));
%R = uint8(R);