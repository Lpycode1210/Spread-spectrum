clear all;
clc;%产生7位m序列，频率为100HZ
X1=0;X2=0;X3=1;
m=350;%重复50遍单极性m序列
for i=1:m
    Y3=X3;Y2=X2;Y1=X1;X3=Y2;X2=Y1;X1=xor(Y3,Y1);
    L(i)=Y1;
end
for i=1:m;
M(i)=1-2*L(i);%将单极性m序列变为双极型m序列
end
k=1:1:m;
figure(1)
subplot(3,1,1)
stem(k-1,M);
axis([0,7,-1,1]);
xlabel('k');
ylabel('m序列');
title('移位寄存器产生的双极性7位m序列');
subplot(3,1,2)
ym=fft(M,4096);
magm=abs(ym);%求双极性m序列频谱
fm=(1:2048)*200/2048;
plot(fm,magm(1:2048)*2/4096);
title('双极性7位m序列的频谱')
axis([90,140,0,0.1]);
[a,b]=xcorr(M,'unbiased');
subplot(3,1,3)%求双极性m序列的自相关函数
plot(b,a);
axis([-20,20,-0.5,1.2]);
title('双极性7位m序列的自相关函数');
%生成50位随机序列，并进行扩频编码，生成频率为100/7HZ（0.07s产生一次），ｍ序列编码后变成100HZ。
N=50;a=0;
x_rand=rand(1,N);
for i=1:N
    if x_rand(i)>=0.5
        x(i)=1;a=a+1;
    else x(i)=0;
    end
end
t=0:N-1;
figure(2)
subplot(2,1,1)
stem(t,x);
title('扩频前待发送信息系列');
tt=0:349;
subplot(2,1,2)
I=1:7*N;
y(I)=0;
for i=1:N
    k=7*i-6;
    y(k)=x(i);k=k+1;y(k)=x(i);k=k+1;y(k)=x(i);k=k+1;y(k)=x(i);k=k+1;y(k)=x(i);
    k=k+1;y(k)=x(i);k=k+1;y(k)=x(i);
end
s(I)=0;
for i=1:350
    s(i)=xor(L(i),y(i));%异或
end
tt=0:7*N-1;
stem(tt,s);
axis([0,350,0,1]);
title('扩频后的待发送序列码');
%进行BPSK调制 2khz
figure(3)
subplot(2,2,1)
fs=2000;
ts=0:0.00001:3.5-0.00001;
s_b=rectpulse(s,1000);
s_bpsk=(1-2.*s_b).*cos(2*pi*fs*ts);
plot(ts,s_bpsk);
xlabel('s');
axis([0.055,0.085,-1.2,1.2])
title('扩频bpsk调制后时域波形');
subplot(2,2,3)
s_bb=rectpulse(x,7000);
s_bpskb=(1-2.*s_bb).*cos(2*pi*fs*ts);
plot(ts,s_bpskb);
xlabel('s');
axis([0.055,0.084,-1.2,1.2]);
title('无扩频bpsk调制后时域波形')
%扩频前后bpsk调制后的频谱
N=400000;
ybb=fft(s_bpskb,N);
magb=abs(ybb);
fbb=(1:N/2)*100000/N;  
subplot(2,2,4)
plot(fbb,magb(1:N/2)*2/N);
axis([1700,2300,0,0.8]);
title('无扩频调制后频谱');
xlabel('Hz');
subplot(2,2,2)
yb=fft(s_bpsk,N);
mag=abs(yb);
fb=(1:N/2)*100000/N;
plot(fb,mag(1:N/2)*2/N);
axis([1700,2300,0,0.8]);
title('扩频调制后频谱');
xlabel('Hz');
figure(5)
subplot(2,2,1)
s_bpskba=awgn(s_bpskb,3,'measured');
plot(ts,s_bpskb,ts,s_bpskba);
axis([0,0.005,-1.2,1.2]);
xlabel('t');
title('无扩频经信道后时域波形');
subplot(2,2,3)
s_bpska=awgn(s_bpsk,3,'measured');
plot(ts,s_bpsk,ts,s_bpska);
title('扩频后经信道后时域波形')
xlabel('t');
axis([0.0675,0.0725,-1.2,1.2]);
subplot(2,2,2)
ybba=fft(s_bpskba,N);
magba=abs(ybba);
plot(fbb,magba(1:N/2)*2/N);
title('无扩频经信道后频谱 ');
axis([1700,2300,0,0.8]);
xlabel('Hz');
subplot(2,2,4)
yba=fft(s_bpska,N);
maga=abs(yba);
fb=(1:N/2)*100000/N;
plot(fb,maga(1:N/2)*2/N);
axis([1700,2300,0,0.8]);
xlabel('Hz');
title('扩频经信道后频谱 ');
figure(6)
title('经过信道两种信号的频谱');
subplot(2,2,1)
plot(fbb,magb(1:N/2)*2/N);
axis([0,4000,0,0.04]);
title('无扩频调制信号频谱');
xlabel('Hz');
subplot(2,2,2)
plot(fbb,magba(1:N/2)*2/N);
axis([0,4000,0,0.04]);
title('无扩频调制信号经过信道频谱');
xlabel('Hz');
subplot(2,2,3)
plot(fb,mag(1:N/2)*2/N);
axis([0,4000,0,0.04]);
title('扩频调制后频谱');
xlabel('Hz');
subplot(2,2,4)
plot(fb,maga(1:N/2)*2/N);
axis([0,4000,0,0.04]);
title('扩频调制经信道后频谱');
xlabel('Hz');
%接收机与载波相乘
figure(7)
subplot(2,2,1)
reb=s_bpskba.*cos(2*pi*fs*ts);
plot(ts,reb);
axis([0.055,0.085,-1.5,1.5]);
xlabel('t');
title('无扩频接收后乘以恢复载波');
subplot(2,2,2)
re=s_bpska.*cos(2*pi*fs*ts);
plot(ts,re);
axis([0.055,0.085,-1.5,1.5]);
xlabel('t');
title('扩频接收后乘以恢复载波');
subplot(2,2,3)
yreb=fft(reb,N);
magreb=abs(yreb);
freb=(1:N/2)*100000/N;
plot(freb,magreb(1:N/2)*2/N);
axis([0,5000,0,0.5]);
title('无扩频接收后乘以载波频谱');
subplot(2,2,4)
yre=fft(re,N);
magre=abs(yre);
plot(freb,magre(1:N/2)*2/N);
axis([0,5000,0,0.5]);
title('扩频接收后乘以载波频谱');
%4Khz出现的需要滤除
figure(8)
subplot(2,2,2)
fp=100;
fc=200;
as=100;
ap=1;
fsw=22000;
wp=2*fp/fsw;
wc=2*fc/fsw;
Nw=ceil((as-7.95)/(14.36*(wc-wp)/2))+1;
beta=0.1102*(as-8.7);
window=kaiser(Nw+1,beta);
b=fir1(Nw,wc,window);
bs=abs(freqz(b,1,400000,fsw))';
plot(bs)
magrebl=bs.*magreb;
plot(freb,magrebl(1:N/2)*2/N);
axis([0,200/7,0,1]);
title('无扩频经过低通滤波器频谱');
xlabel('Hz');
subplot(2,2,4)
magrel=bs.*magre;
plot(freb,magrel(1:N/2)*2/N);
title('扩频经过低通滤波器频谱');
axis([0,200,0,0.4]);
xlabel('Hz');
subplot(2,2,1)
yrebl=real(ifft(bs.*yreb,400000));
tm=(1:N)/N*4;
plot(tm,yrebl);
xlabel('t');
title('无扩频经过低通滤波器时域波形');
subplot(2,2,3)
yrel=real(ifft(bs.*yre,400000));
plot(tm,yrel);
xlabel('t');
title('扩频经过低通滤波器时域波形');
figure(9)%对扩频解扩
subplot(2,2,1)
jj=rectpulse(M,1000);
yrej=jj.*yrel(1:350000);
plot(ts(1:350000),yrej);
xlabel('t');
axis([0,4,-0.5,0.5]);
title('解扩后时域');
subplot(2,1,2)
yj=fft(yrej,N);
magj=abs(yj);
plot(freb,magj(1:N/2)*2/N);
axis([0,500,0,0.2]);
title('解扩后频谱');
xlabel('Hz');
figure(10)
subplot(2,2,1)
plot(freb,magrel(1:N/2)*2/N);
axis([0,200,0,0.4]);
title('解扩前信号频偏');
subplot(2,2,2)
plot(freb,magj(1:N/2)*2/N);
axis([0,200,0,0.4]);
title('解扩后信号频偏');
subplot(2,2,3)
yjb=fft(yrel,N);
prelb=yjb.*conj(yjb)/N;
plot(freb,prelb(1:N/2)*2/N);
axis([0,200,0,0.01]);
title('解扩前信号功率谱');
xlabel('Hz');
subplot(2,2,4)
yj=fft(yrej,N);
prel=yj.*conj(yj)/N;
plot(freb,prel(1:N/2)*2/N);
axis([0,200,0,0.01]);
title('解扩后信号功率谱');
xlabel('Hz');
figure(11)%对解扩信号采样判决
subplot(2,1,1)
for i=1:1:350
    ij=i*1000-500;
    ss(i)=yrej(ij);
end
stem(ss);
title('解扩信号采样');
subplot(2,1,2)
for i=1:1:350
    if ss(i)>0.2
        ss(i)=1;
    elseif ss(i)<-0.2
        ss(i)=-1;
    else ss(i)=0;
    end
end
for i=1:1:50
    ij=7*i-6;
    if ss(ij)==0
        ss(ij)=ss(ij+4);
    end
end
for i=1:1:348
    if ss(i)==0
        ss(i)=ss(i+2);
    end
end
for i=1:1:50
    S(i)=ss(i*7-3);
    if S(i)==0
        S(i)=S(i)+1;
    end
    S(i)=(1-S(i))/2;
end
stem(S);
title('判决后的信号');
figure(12)%增加窄带强干扰
subplot(2,1,1)
fd=200000;
Wp1=2*2040/fd;
Wp2=2*2050/fd;
Wc1=2*2030/fd;
Wc2=2*2060/fd;
Ap=1;
As=100;
W1=(Wp1+Wc1)/2;
W2=(Wp2+Wc2)/2;
wdth=min((Wp1-Wc1),(Wc2-Wp2));
Nd=ceil(11*pi/wdth)+1;
bd=fir1(Nd,[W1 W2]);
zd(1)=1;
for i=2:1:350000
    zd(i)=0;
end
ds=abs(freqz(bd,1,400000,fd))';
ybz=fft(zd,N)*100000;
magz=abs(ybz);
dz=ds.*magz;
dsz=maga+dz;
magrelz=magrel;%%%%%%
plot(freb,dz(1:N/2)*2/N,freb,maga(1:N/2)*2/N);
xlabel('Hz');
axis([1700,2300,0,0.6]);
title('经过加入窄带强干扰的信道后频谱');
subplot(2,1,2)
rez=real(ifft(dz,N));
ts=(1:N)/N*4;
yzz=rez.*cos(2*pi*2000*ts);
yz=fft(yzz,N);
magyz=abs(yz);
renz=real(ifft(maga,N));
ynzz=renz.*cos(2*pi*2000*ts);
ynz=fft(ynzz,N);
magynz=abs(ynz);
plot(freb,magyz(1:N/2)*2/N,freb,magynz(1:N/2)*2/N);
axis([0,5000,0,0.2]);
title('解调后频谱');
figure(13)
subplot(4,1,1)
magyzl=bs.*magyz;
magynzl=bs.*magynz;
plot(freb,magyzl(1:N/2)*2/N,freb,magynzl(1:N/2)*2/N);
axis([0,200,0,0.2]);
xlabel('Hz');
title('信号经过低通滤波后频谱');
subplot(4,1,2)
yrnzl=real(ifft(bs.*yre,400000));
yrzl=real(ifft(magynzl,400000));
tm=(1:N)/N*4;
yrnzlj=jj.*yrnzl(1:350000);
yrzlj=jj.*yrzl(1:350000);
plot(ts(1:350000),yrnzlj+yrzlj);
xlabel('t');
axis([0,4,-1.5,1.5]);
title('解扩后时域波形');
subplot(4,1,3)
yzj=fft(yrzlj,N);
magzj=abs(yzj);
ynzj=fft(yrnzlj,N);
magnzj=abs(ynzj);
plot(freb,magzj(1:N/2)*2/N,freb,magnzj(1:N/2)*2/N);
axis([0,500,0,0.2]);
title('解扩后频谱');
xlabel('Hz');
subplot(4,1,4)
prelnz=ynzj.*conj(ynzj)/N;
prelz=yzj.*conj(yzj)/N;
plot(freb,prelnz(1:N/2)*2/N,freb,prelz(1:N/2)*2/N);
axis([0,100,0,0.007]);
xlabel('Hz');
title('解扩后功率谱')
















