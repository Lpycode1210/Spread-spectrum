
clear;

% 维纳滤波器的长度
N = 10;

% 生成信号的角度范围（从0到2π）
x = linspace(0, 2 * pi, 500); % 500个点

% 定义期望信号为 y_desired = sin(x)
y_desired = sin(x);

% 生成观测噪声（均值为0，方差为0.06的高斯噪声）
noise_std = sqrt(0.06);
y_noise = noise_std * randn(1, 500);

% 生成观测信号 y_observed
y_observed = y_desired + y_noise;

% 计算观测信号的自相关矩阵 R_yy
r_y = xcorr(y_observed, 'biased'); % 使用有偏估计
%R_yy = toeplitz(r_y(500:499 + N)); % 使用Toeplitz矩阵构造自相关矩阵

% 手动构造自相关矩阵 R_yy
R_yy = zeros(N, N); % 初始化为零矩阵
for i = 1:N
    for j = 1:N
        R_yy(i, j) = r_y(500 + abs(i - j)); % 根据偏移量填充自相关值
    end
end

% 计算观测信号与期望信号的互相关向量 P_yd
r_yd = xcorr(y_observed, y_desired, 'biased');
P_yd = r_yd(500:499 + N)';

% 由维纳-霍夫方程得到的滤波器最优解
opt_w = R_yy \ P_yd;

% 滤波后y方向上的输出
y_filtered = conv(y_observed, opt_w, 'same'); % 使用'same'保持原长度

% 计算最小均方误差
emin = mean((y_desired - y_filtered) .^ 2);

% 打印最小均方误差
fprintf('最小均方误差: %.4f\n', emin);

% 绘制结果
figure;
subplot(2, 2, 1);
plot(x, y_desired);
title('期望信号 y\_desired');

subplot(2, 2, 2);
plot(x, y_noise);
title('噪声信号 y\_noise');

subplot(2, 2, 3);
plot(x, y_observed);
title('观测信号 y\_observed');

subplot(2, 2, 4);
plot(x, y_filtered);
title('滤波后信号 y\_filtered');

% 对比期望信号、观测信号和滤波后信号
figure;
plot(x, y_desired, 'k', 'DisplayName', '期望信号');
hold on;
plot(x, y_observed, 'b:', 'DisplayName', '观测信号');
plot(x, y_filtered, 'g-', 'DisplayName', '滤波后信号');
title('期望信号、观测信号和滤波后信号对比');
legend;
hold off;
