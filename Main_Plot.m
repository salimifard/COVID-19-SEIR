clc;
clear
close all;
drawnow;
tic;

%% Load Data from Excel
s_real = xlsread('complete file of data', 'sheet3', 'K2:K37');
e_real = xlsread('complete file of data', 'sheet3', 'N2:N37');
i_real = xlsread('complete file of data', 'sheet3', 'Q2:Q37');
r_real = xlsread('complete file of data', 'sheet3', 'T2:T37');

Time_real = (1:numel(s_real)).';

%% Load data
Data_File;

%% Time
we = 36; % start poeint (week)

s0   = s_real(we);    % Afrade mostaed
e0   = e_real(we);  % Bimare-bedoone-alamat
i0   = i_real(we);  % Bimar
% r: Behbood yafteh

ops.Interpreter = 'tex';
Time = Time_real(end);  % Total simulation time (week)
defAns = {num2str(Time),num2str(s0),num2str(e0),num2str(i0)};
Answer = inputdlg({
    '\bf\fontname{Courier}\fontsize{12} Total time: (rooz)',...
    '\bf\fontname{Courier}\fontsize{12} s0:', ...
    '\bf\fontname{Courier}\fontsize{12} e0:', ...
    '\bf\fontname{Courier}\fontsize{12} i0:'},...
    'Input data:', [1 60], defAns, ops);
Time = str2double(Answer{1}); % week
s0   = str2double(Answer{2});
e0   = str2double(Answer{3});
i0   = str2double(Answer{4});
X_Initial = [s0; e0; i0];

%% ODE45
[Time,y_ode45]=ode45(@Myfun,[0 Time],X_Initial);
s = y_ode45(:,1);
e = y_ode45(:,2);
i = y_ode45(:,3);
r = 1-s-e-i;

%% State variables
figure;
plot(Time, s, 'r--', 'LineWidth', 1.5);
hold on
plot(Time, e, 'b-.', 'LineWidth', 1.5);
plot(Time, i, 'k:',  'LineWidth', 2 );
plot(Time, r, 'g-',  'LineWidth', 2);
title('SEIR')
xlabel('Time (week)');
ylabel('s, e, i, r');
grid on
legend('s','e','i', 'r');
set(gca,'Fontweight','Bold', ...
    'FontName','Times New Roman','Fontsize',14);

%% 4 plot
figure;
plot(Time_real, s_real, 'r--', 'LineWidth', 1.5);
hold on
plot(Time_real, e_real, 'b-.', 'LineWidth', 1.5);
plot(Time_real, i_real, 'k:',  'LineWidth', 2 );
plot(Time_real, r_real, 'g-',  'LineWidth', 2);
title('Real data')
xlabel('Time (week)');
ylabel('s, e, i, r');
grid on
legend('s','e','i', 'r');
set(gca,'Fontweight','Bold', ...
    'FontName','Times New Roman','Fontsize',14);

%% 4 plot
figure;
plot(Time_real, e_real, 'b-.', 'LineWidth', 1.5);
hold on
plot(Time_real, i_real, 'k:',  'LineWidth', 2 );
plot(Time_real, r_real, 'g-',  'LineWidth', 2);
title('Real data')
xlabel('Time (week)');
ylabel('e, i, r');
grid on
legend('e','i', 'r');
set(gca,'Fontweight','Bold', ...
    'FontName','Times New Roman','Fontsize',14);

%% Speed
figure;
Inew = i_real;
Th = numel(Time_real);
for t=1:Th-1
    Speed_I(t,1) = (Inew(t+1)-Inew(t))/(Time_real(t+1)-Time_real(t));
end
plot(Time_real(1:Th-1), Speed_I, 'r--', 'LineWidth', 1.5);

xlabel('Time (week)');
ylabel('Speed');
grid on
set(gca,'Fontweight','Bold', ...
    'FontName','Times New Roman','Fontsize',14);

%% the squared Mahalanobis distance
X_real = [s_real, e_real, i_real];
X_SEIR = [s, e, i];
m = [1, 0.0, 0.0];
MD_real = sqrt(mahal(m,X_real))
MD_SEIR = sqrt(mahal(m,X_SEIR))

%% Compair
figure('name', 'Compair', 'Position', [301    54   887   627]);
subplot(3,1,1)
plot(     Time,      s, 'b-.', 'LineWidth', 1.5);
hold on
plot(Time_real, s_real, 'r--', 'LineWidth', 1.5);
ylabel('s');
grid on
legend('SEIR', 'Real');
set(gca,'Fontweight','Bold', ...
    'FontName','Times New Roman','Fontsize',14);

subplot(3,1,2)
plot(     Time,      e, 'b-.', 'LineWidth', 1.5);
hold on
plot(Time_real, e_real, 'r--', 'LineWidth', 1.5);
ylabel('e');
grid on
legend('SEIR', 'Real');
set(gca,'Fontweight','Bold', ...
    'FontName','Times New Roman','Fontsize',14);

subplot(3,1,3)
plot(     Time,      i, 'b-.', 'LineWidth', 1.5);
hold on
plot(Time_real, i_real, 'r--', 'LineWidth', 1.5);
xlabel('Time (week)');
ylabel('i');
grid on
legend('SEIR', 'Real');
set(gca,'Fontweight','Bold', ...
    'FontName','Times New Roman','Fontsize',14);