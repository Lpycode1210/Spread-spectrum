clear;
% 卡尔曼滤波技术示例

% 定义参数
N = 200;                          % 状态序列长度
F = 1;                            % 状态转移矩阵（常值）
C = 1;                            % 观测矩阵（常值）

% 初始化真实状态、过程噪声和测量噪声
X_real = zeros(1, N);             % 真实状态初始化
process_noise = randn(1, N);      % 过程噪声 (高斯分布)
measurement_noise = randn(1, N);  % 测量噪声 (高斯分布)

% 生成真实状态数据
for k = 2:N
    X_real(k) = F * X_real(k-1) + process_noise(k-1);
end

% 生成观测数据
Z = C * X_real + measurement_noise;

% 估计过程和测量噪声的协方差
Q = var(process_noise);  % 过程噪声协方差
R = var(measurement_noise); % 测量噪声协方差

% 初始化卡尔曼滤波变量
X_pre = zeros(1, N);     % 状态预测
X_flt = zeros(1, N);     % 滤波后的状态估计
P_pre = zeros(1, N);     % 预测协方差
P = zeros(1, N);         % 滤波协方差
K = zeros(1, N);         % 卡尔曼增益

% 初始值
X_pre(1) = Z(1);         % 初始预测状态
X_flt(1) = Z(1);         % 初始滤波状态
P(1) = 10;               % 初始协方差

% 卡尔曼滤波器主循环
for t = 2:N
    % 一步预测
    X_pre(t) = F * X_flt(t-1);
    P_pre(t) = F * P(t-1) * F' + Q;
    
    % 更新阶段
    innovation_cov = C^2 * P_pre(t) + R;  % 新息协方差
    K(t) = C * P_pre(t) / innovation_cov; % 卡尔曼增益
    innovation = Z(t) - C * X_pre(t);     % 新息（测量残差）
    
    % 状态更新
    X_flt(t) = X_pre(t) + K(t) * innovation;
    
    % 协方差更新
    P(t) = (1 - K(t) * C) * P_pre(t);
end

% 绘图
t = 1:N;
figure;
plot(t, X_real, 'b', 'LineWidth', 1.5); hold on;
plot(t, Z, 'g', 'LineWidth', 1.2);
plot(t, X_flt, 'r', 'LineWidth', 1.5);
legend('真实值', '观测值', '卡尔曼滤波结果');
xlabel('时间步');
ylabel('状态值');
title('卡尔曼滤波效果');
grid on;

% 计算性能评估指标
rmse_kalman = sqrt(mean((X_flt - X_real).^2)); % 卡尔曼滤波RMSE
rmse_observation = sqrt(mean((Z - X_real).^2)); % 观测值的RMSE

% 输出性能对比
fprintf('卡尔曼滤波RMSE: %.4f\n', rmse_kalman);
fprintf('观测值RMSE: %.4f\n', rmse_observation);
