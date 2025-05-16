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

% 初始化LMS算法参数
mu = 0.01; % 学习率（步长）
w = zeros(N, 1); % 初始化权重向量
num_samples = length(y_observed); % 样本数
y_filtered = zeros(1, num_samples); % 存储滤波后的输出信号

% LMS算法迭代更新权重
for n = N:num_samples
    % 提取当前输入信号向量 x(n)
    u = y_observed(n:-1:n-N+1)'; % 长度为 N 的观测信号向量，倒序排列
    
    % 计算当前输出信号
    y_hat = w' * u;
    
    % 计算当前误差 e(n)
    e = y_desired(n) - y_hat;
    
    % 更新权重向量
    w = w + mu * e * u;
    
    % 保存滤波输出
    y_filtered(n) = y_hat;
end

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
