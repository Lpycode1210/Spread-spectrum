function code=PCMcoding(S)
z=sign(S);%
MaxS=max(abs(S));
S=abs(S/MaxS);%对采样信号S进行归一化
Q=2048*S;%对采样S进行量化，分为2048个区间，采样13折线律作为压缩律进行非均匀量化
code=zeros(length(S),8);
%段落码判断程序
for i=1:length(S)
    if (Q(i)>=128)&&(Q(i)<=2048)
        code(i,2)=1;%对段位码的第一位进行判断
    end
    if (Q(i)>32)&&(Q(i)<128)||(Q(i)>=512)&&(Q(i)<=2048)
        code(i,3)=1;%对段位码的第二位进行判断
    end
    if (Q(i)>=16)&&(Q(i)<32)||(Q(i)>=64)&&(Q(i)<128)||(Q(i)>=256)&&(Q(i)<512)||(Q(i)>=1024)&&(Q(i)<=2048)
        code(i,4)=1;%对段位码的第三位进行判断
    end
end
%段内码判断程序
N=zeros(length(S));
for i=1:length(S)
    N(i)=bin2dec(num2str(code(i,2:4)))+1;%判断该量化数值所在段位
end
a=[0,16,32,64,128,256,512,1024];%段落起始电平
b=[1,1,2,4,8,16,32,64];%段内量化间隔
for i=1:length(S)
    q=ceil((Q(i)-a(N(i)))/b(N(i)));%求段内码（10进制）
    if q==0
        code(i,(5:8))=[0,0,0,0];
    else k=num2str(dec2bin(q-1,4));%进行段内码10进制与2进制之间的转换
        code(i,5)=str2num(k(1));
        code(i,6)=str2num(k(2));
        code(i,7)=str2num(k(3));
        code(i,8)=str2num(k(4));
    end
    if z(i)>0%判断编码的正负（8位码组的第1位）
        code(i,1)=1;
    elseif z(i)<0
        code(i,1)=0;
    end
end
code=reshape(code',1,[]);
end