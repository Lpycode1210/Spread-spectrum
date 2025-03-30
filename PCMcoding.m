function code=PCMcoding(S)
z=sign(S);%
MaxS=max(abs(S));
S=abs(S/MaxS);%�Բ����ź�S���й�һ��
Q=2048*S;%�Բ���S������������Ϊ2048�����䣬����13��������Ϊѹ���ɽ��зǾ�������
code=zeros(length(S),8);
%�������жϳ���
for i=1:length(S)
    if (Q(i)>=128)&&(Q(i)<=2048)
        code(i,2)=1;%�Զ�λ��ĵ�һλ�����ж�
    end
    if (Q(i)>32)&&(Q(i)<128)||(Q(i)>=512)&&(Q(i)<=2048)
        code(i,3)=1;%�Զ�λ��ĵڶ�λ�����ж�
    end
    if (Q(i)>=16)&&(Q(i)<32)||(Q(i)>=64)&&(Q(i)<128)||(Q(i)>=256)&&(Q(i)<512)||(Q(i)>=1024)&&(Q(i)<=2048)
        code(i,4)=1;%�Զ�λ��ĵ���λ�����ж�
    end
end
%�������жϳ���
N=zeros(length(S));
for i=1:length(S)
    N(i)=bin2dec(num2str(code(i,2:4)))+1;%�жϸ�������ֵ���ڶ�λ
end
a=[0,16,32,64,128,256,512,1024];%������ʼ��ƽ
b=[1,1,2,4,8,16,32,64];%�����������
for i=1:length(S)
    q=ceil((Q(i)-a(N(i)))/b(N(i)));%������루10���ƣ�
    if q==0
        code(i,(5:8))=[0,0,0,0];
    else k=num2str(dec2bin(q-1,4));%���ж�����10������2����֮���ת��
        code(i,5)=str2num(k(1));
        code(i,6)=str2num(k(2));
        code(i,7)=str2num(k(3));
        code(i,8)=str2num(k(4));
    end
    if z(i)>0%�жϱ����������8λ����ĵ�1λ��
        code(i,1)=1;
    elseif z(i)<0
        code(i,1)=0;
    end
end
code=reshape(code',1,[]);
end