function s=PCMdecoding(encode,max)
encode=(reshape(encode',8,length(encode)/8))';%对码元进行重组，每8个为一组
I=size(encode,1);
a=[0,16,32,64,128,256,512,1024];%量化区间
b=[1 1 2 4 8 16 32 64];%段落量化间隔
c=[0 1.5:15.5];%段内量化间隔
for i=1:I
    x=encode(i,1);
    T=bin2dec(num2str(encode(i,(2:4))))+1;%2进制与10进制之间转换，求所在段（10进制）
    Y=bin2dec(num2str(encode(i,(5:8))));%2进制与10进制之间转换，求段内所在位置（10进制）
    if Y==0
        k(i)=a(T)/2048;%段内码为0
    else
        k(i)=(a(T)+b(T)*c(Y))/2048;%量化后平均值
    end
    if x==0
        s(i)=-k(i);%判断符号
    else
        s(i)=k(i);
    end
end
s=s*max;
end