clear all;
clc;% ���庯�� f(x)% ��������
x = linspace(0, 1, 11);  % ������[0,1]�ϵȼ��ȡ11����
f_x = 0.5 + 0.4 * sin(2 * pi * x);  % ԭʼ����
noise = normrnd(0, 0.05, size(f_x));  % �����ֵΪ0������Ϊ0.05�ĸ�˹����
y = f_x + noise;  % ������������

% ����ԭʼ���ݺʹ�����������
figure;
subplot(2, 1, 1);
plot(x, f_x, 'b-', 'LineWidth', 2);  % ԭʼ��������
hold on;
scatter(x, y, 'ro');  % ��������ѵ������
title('Original Function and Noisy Data');
legend('Original Function', 'Noisy Data');

% ���ж���ʽ���
% ���1�׶���ʽ
p1 = polyfit(x, y, 1);
y_fit_1 = polyval(p1, x);

% ���3�׶���ʽ
p3 = polyfit(x, y, 3);
y_fit_3 = polyval(p3, x)

% ���10�׶���ʽ
p10 = polyfit(x, y, 10);
y_fit_10 = polyval(p10, x);

% ������Ͻ��
subplot(2, 1, 2);
plot(x, f_x, 'b-', 'LineWidth', 2);  % ԭʼ��������
hold on;
plot(x, y_fit_1, 'r-', 'LineWidth', 2);  % 1�����
plot(x, y_fit_3, 'g-', 'LineWidth', 2);  % 3�����
plot(x, y_fit_10, 'm-', 'LineWidth', 2);  % 10�����
title('Polynomial Fitting Results');
legend('Original Function', '1st Order Fit', '3rd Order Fit', '10th Order Fit');
grid on;

% ��ʾͼ��
