%%语音信号抽样
load chirp;
data01=zeros(1,length(y));
data02=zeros(1,length(y));
xdata1=0:(1/Fs):(length(y)-1)*(1/Fs);
fs=Fs;
xdata2=0:(1/fs):(length(y)-1)*(1/fs);
for i=1:1:length(y)
    data01(1,i)=y(i,1);
end
for i=1:1:length(y)
    data02(1,i)=y(i,1);
end
maximum1=max(abs(data02));
figure;
subplot(211);plot(xdata1,data01);title('原始信号');grid on;
subplot(212);stem(xdata2,data02,'.');title('抽样信号');grid on;
sound(y,Fs);
%%信号编码
pcm_encode1=PCMcoding(data02);
figure;
stairs(pcm_encode1);
axis([0 200 -2 2]);
title('PCM编码');
grid on;
%%信号译码
pcm_decode1=PCMdecoding(pcm_encode1, maximum1);
%%PCM输出
figure;
subplot(211);plot(xdata2,pcm_decode1);
title('PCM 译码');grid on;
subplot(212);plot(xdata1,data01);
title('原始信号');grid on;
sound(pcm_decode1,fs);
