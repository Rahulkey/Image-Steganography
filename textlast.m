
%cover image
clear all;
close all;
clc;
a1=imread('pic1.jpg');
figure(),imshow(a1),title('cover image');
a=a1(:,:,1);
t1=a1(:,:,2);
t2=a1(:,:,3);
%a=rgb2gray(a1);
[r,c]=size(a);
a=im2double(a);
a=a*255;
b=8;
n1=(floor(r/(b)))*b;
n2=(floor(c/b))*b;
a=imresize(a,[n1,n2]);
t1=imresize(t1,[n1,n2]);
t2=imresize(t2,[n1,n2]);
I=a;
z=zeros(n1,n2);

for i=1:b:n1
    for j=1:b:n2
      f=I(i:i+b-1,j:j+b-1);
      f1=dct2(f);
      z(i:i+b-1,j:j+b-1)=f1;
    end
end
figure(2),imshow(z/255);

quantization_table = [
 16  11  10  16  24   40   51   61;
 12  12  14  19  26   58   60   55;
 14  13  16  24  40   57   69   56;
 14  17  22  29  51   87   80   62;
 18  22  37  56  68   109  103  77;
 24  35  55  64  81   104  113  92;
 49  64  78  87  103  121  120  101;
 72  92  95  98  112  100  103  99
    ];

quant1=zeros(n1,n2);

    for i=1:b:n1
        for j=1:b:n2
            for ii=1:b
                for jj=1:b
                    aa=z(i+ii-1,j+jj-1);
                    quant1(i+ii-1,j+jj-1)=(aa/quantization_table(ii,jj));
                end
            end
        end
    end
    quant=round(quant1);
%figure(3),imshow(quant/255);

%secret text

M = input('\nEnter message: ','s');
x=length(M);
for j= 1:x
    for i=1:122
        if strcmp(M(j),char(i))
            te(j)=i;
        end
    end
end
[r2,c2]=size(te);
t=r2*c2;
ct=1;
for i=1:122
    k=te==i;
    [rr,cc]=size(k);
    count1=0;
    for j=1:cc
    count1=count1+k(j);
    end
    pro(ct)=count1/t;
    ct=ct+1;
end;
pro=pro(1:122);
symbols = [1:122];

dict = huffmandict(symbols,pro);

hcode = huffmanenco(te,dict);
[n5,n6]=size(hcode);

% Encoding
qq=1;
for i=1:n1
    for j=1:n2
        co(qq)=quant(i,j);
        qq=qq+1;
    end
end

qq=1;
for i=1:n1*n2
if co(i)>0
c=de2bi(co(i),8,'left-msb');
elseif co(i)==0
    c=[0 0 0 0 0 0 0 0];
else
    t=255+co(i);
    c=de2bi(t,8,'left-msb');
end
for j=1:8
cov(qq,j)=c(j);
end
qq=qq+1;
end

tt=1;
for i=1:n1*n2
    if(tt>n6)
        break
    end
    if(co(i)~=0 && co(i)~=1 && co(i)~=-1 )
    cov(i,8)=hcode(tt);
    tt=tt+1;
    end
end

cov1=bi2de(cov,'left-msb');

for i=1:n1*n2
if co(i)<0
    cov1(i)=cov1(i)-255;
else
    cov1(i)=cov1(i);
end
end

cov2=zeros(n1,n2);
qq=1;
for i=1:n1
    for j=1:n2
        cov2(i,j)=cov1(qq);
        qq=qq+1;
    end
end

quant=zeros(n1,n2);

    for i=1:b:n1
        for j=1:b:n2
            for ii=1:b
                for jj=1:b
                    aa=cov2(i+ii-1,j+jj-1);
                    quant(i+ii-1,j+jj-1)=(aa*quantization_table(ii,jj));
                end
            end
        end
    end

z11=zeros(n1,n2);
for i=1:b:n1
    for j=1:b:n2
      f=quant(i:i+b-1,j:j+b-1);
      f1=idct2(f);
      z11(i:i+b-1,j:j+b-1)=f1;
    end
end
%figure(),imshow(z11/255),title('final grayscale image');
%z1=round(z11);
fi=cat(3,z11,t1,t2);
figure(),imshow(fi),title('stego image');
imwrite(fi,'stego01.jpg');

%decoding of secret image

s=fi(:,:,1);
s1=im2double(s);
s1=s1*255;

[n7,n8]=size(s1);
s2=zeros(n7,n8);
for i=1:b:n7
    for j=1:b:n8
        s3=s1(i:i+b-1,j:j+b-1);
        s4=dct2(s3);
        s2(i:i+b-1,j:j+b-1)=s4;
    end
end
s2=round(s2);
quant1=zeros(n1,n2);

    for i=1:b:n1
        for j=1:b:n2
            for ii=1:b
                for jj=1:b
                    aa=s2(i+ii-1,j+jj-1);
                    quant1(i+ii-1,j+jj-1)=(aa/quantization_table(ii,jj));
                end
            end
        end
    end
    quant1=round(quant1);
    qq=1;
    for i=1:n7
        for j=1:n8
            s5(qq)=quant1(i,j);
            qq=qq+1;
        end
    end
    
    qq=1;
for i=1:round(n7*n8)
if s5(i)>0
c=de2bi(s5(i),8,'left-msb');
elseif s5(i)==0
    c=[0 0 0 0 0 0 0 0];
else
    t=255+s5(i);
    c=de2bi(t,8,'left-msb');
end
for j=1:8
s6(qq,j)=c(j);
end
qq=qq+1;
end

qq=1;
j=1;
while qq<=n6
    if(s5(j)~=0 && s5(j)~=1 && s5(j)~=-1)
    s7(qq)=s6(j,8);
    qq=qq+1;
    end
    j=j+1;    
end
s8=s7(1:n6);
h2=huffmandeco(s8,dict);
'decode text: '
char(h2)
