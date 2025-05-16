clear;
% 卡尔曼滤波器：位置和速度估计（加入噪声）

% 参数定义
N = 200;                          % 状态序列长度
dt = 1;                           % 采样时间间隔
true_velocity = 0.1;                % 固定真实速度

% 系统模型
F = [1, dt; 0, 1];                % 状态转移矩阵
C = [1, 0];                       % 观测矩阵（仅观测位置）

% 初始化真实状态、过程噪声和测量噪声
X_real = zeros(2, N);             % 真实状态 (位置和速度)
process_noise = [1; 0] .* randn(2, N); % 过程噪声（仅作用于位置）
measurement_noise = 1.2.*randn(1, N);  % 测量噪声 (高斯分布)

% 生成真实状态数据
X_real(:, 1) = [0; true_velocity]; % 初始位置为0，速度为true_velocity
for k = 2:N
    X_real(:, k) = F * X_real(:, k-1) + process_noise(:, k-1);
end

% 生成观测数据
Z = C * X_real + measurement_noise;

% 噪声协方差
Q = diag([0.1, 0.01]); % 过程噪声协方差 (位置噪声较大，速度噪声较小)
R = var(measurement_noise); % 测量噪声协方差

% 初始化卡尔曼滤波变量
X_pre = zeros(2, N);     % 状态预测 (位置和速度)
X_flt = zeros(2, N);     % 滤波后的状态估计 (位置和速度)
P_pre = zeros(2, 2, N);  % 预测协方差
P = zeros(2, 2, N);      % 滤波协方差
K = zeros(2, 1, N);      % 卡尔曼增益

% 初始值
X_pre(:, 1) = [Z(1); 0]; % 初始预测状态
X_flt(:, 1) = [Z(1); 0]; % 初始滤波状态
P(:, :, 1) = eye(2) * 10; % 初始协方差

% 卡尔曼滤波器主循环
for t = 2:N
    % 一步预测
    X_pre(:, t) = F * X_flt(:, t-1);
    P_pre(:, :, t) = F * P(:, :, t-1) * F' + Q;
    
    % 更新阶段
    innovation_cov = C * P_pre(:, :, t) * C' + R; % 新息协方差
    K(:, :, t) = P_pre(:, :, t) * C' / innovation_cov; % 卡尔曼增益
    innovation = Z(t) - C * X_pre(:, t); % 新息（测量残差）
    
    % 状态更新
    X_flt(:, t) = X_pre(:, t) + K(:, :, t) * innovation;
    
    % 协方差更新
    P(:, :, t) = (eye(2) - K(:, :, t) * C) * P_pre(:, :, t);
end

% 观测值直接估计的速度
observed_velocity = diff(Z) / dt;          % 通过差分计算观测速度
observed_velocity = [observed_velocity(1), observed_velocity]; % 保持长度一致

% 计算RMSE
% 1. 直接使用观测值的RMSE
rmse_observed_position = sqrt(mean((Z - X_real(1, :)).^2)); % 位置RMSE
rmse_observed_velocity = sqrt(mean((observed_velocity - X_real(2, :)).^2)); % 速度RMSE

% 2. 卡尔曼滤波后的RMSE
rmse_kalman_position = sqrt(mean((X_flt(1, :) - X_real(1, :)).^2)); % 位置RMSE
rmse_kalman_velocity = sqrt(mean((X_flt(2, :) - X_real(2, :)).^2)); % 速度RMSE

% 输出性能对比
fprintf('观测位置RMSE: %.4f\n', rmse_observed_position);
fprintf('卡尔曼滤波位置RMSE: %.4f\n', rmse_kalman_position);
fprintf('观测速度RMSE: %.4f\n', rmse_observed_velocity);
fprintf('卡尔曼滤波速度RMSE: %.4f\n', rmse_kalman_velocity);

% 绘图
t = 1:N;
figure;
subplot(2, 1, 1);
plot(t, X_real(1, :), 'b', 'LineWidth', 1.5); hold on;
plot(t, Z, 'g', 'LineWidth', 1.2);
plot(t, X_flt(1, :), 'r', 'LineWidth', 1.5);
legend('真实位置', '观测值', '卡尔曼滤波位置估计');
xlabel('时间步');
ylabel('位置');
title('位置估计');
grid on;

subplot(2, 1, 2);
plot(t, X_real(2, :), 'b', 'LineWidth', 1.5); hold on;
plot(t, observed_velocity, 'g', 'LineWidth', 1.2);
plot(t, X_flt(2, :), 'r', 'LineWidth', 1.5);
legend('真实速度', '观测速度', '卡尔曼滤波速度估计');
xlabel('时间步');
ylabel('速度');
title('速度估计');
grid on;
