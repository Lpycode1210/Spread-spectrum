clear all;
clc;% 定义函数 f(x)% 参数设置
x = linspace(0, 1, 11);  % 在区间[0,1]上等间隔取11个点
f_x = 0.5 + 0.4 * sin(2 * pi * x);  % 原始函数
noise = normrnd(0, 0.05, size(f_x));  % 加入均值为0，方差为0.05的高斯噪声
y = f_x + noise;  % 带噪声的数据

% 绘制原始数据和带噪声的数据
figure;
subplot(2, 1, 1);
plot(x, f_x, 'b-', 'LineWidth', 2);  % 原始函数曲线
hold on;
scatter(x, y, 'ro');  % 带噪声的训练数据
title('Original Function and Noisy Data');
legend('Original Function', 'Noisy Data');

% 进行多项式拟合
% 拟合1阶多项式
p1 = polyfit(x, y, 1);
y_fit_1 = polyval(p1, x);

% 拟合3阶多项式
p3 = polyfit(x, y, 3);
y_fit_3 = polyval(p3, x)

% 拟合10阶多项式
p10 = polyfit(x, y, 10);
y_fit_10 = polyval(p10, x);

% 绘制拟合结果
subplot(2, 1, 2);
plot(x, f_x, 'b-', 'LineWidth', 2);  % 原始函数曲线
hold on;
plot(x, y_fit_1, 'r-', 'LineWidth', 2);  % 1阶拟合
plot(x, y_fit_3, 'g-', 'LineWidth', 2);  % 3阶拟合
plot(x, y_fit_10, 'm-', 'LineWidth', 2);  % 10阶拟合
title('Polynomial Fitting Results');
legend('Original Function', '1st Order Fit', '3rd Order Fit', '10th Order Fit');
grid on;

% 显示图像
