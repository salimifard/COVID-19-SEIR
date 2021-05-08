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

%% Equation
syms s e i posetive

d_s = A-Alpha*e-Alpha*i-Beta*s*i-B*s; % Eq (18)
d_e = Beta*s*i-C*e;                   % Eq (18)
d_i = Sigma*e-D*i;                    % Eq (18)

G = d_s; % Eq (27)
H = d_e; % Eq (27)
K = d_i; % Eq (27)

%% Stady state
Answer = solve([G==0, H==0, K==0], [s e i]);
s_star = Answer.s;
e_star = Answer.e;
i_star = Answer.i;

if e_star(2)+ i_star(2)==0
    X_EE   = double([s_star(1); e_star(1); i_star(1)]); % Eq (26)
    X_DFE  = double([s_star(2); e_star(2); i_star(2)]); % Eq (25)
else
    X_DFE    = double([s_star(1); e_star(1); i_star(1)]); % Eq (26)
    X_EE   = double([s_star(2); e_star(2); i_star(2)]); % Eq (25)
end

%% Time
% R: behbood-yafteh
% S: Mostaed
% E: Bimar-bedoone-alamat
% I: Bimar
We = 10;

s0   = s_real(We);  % Mostaed
e0   = e_real(We);  % Bimare-bedoone-alamat
i0   = i_real(We);  % Bimar

ops.Interpreter = 'tex';
defAns = {num2str(s0),num2str(e0),num2str(i0)};
Answer = inputdlg({
    '\bf\fontname{Courier}\fontsize{12} s0:', ...
    '\bf\fontname{Courier}\fontsize{12} e0:', ...
    '\bf\fontname{Courier}\fontsize{12} i0:'},...
    'Input data:', [1 60], defAns, ops);
s0   = str2double(Answer{1});
e0   = str2double(Answer{2});
i0   = str2double(Answer{3});
X_Initial = [s0; e0; i0];

%% ODE45
options = odeset('MaxStep',0.1);
[Time,y_ode45]=ode45(@Myfun,[0 1000],X_Initial, options);
s = y_ode45(:,1);
e = y_ode45(:,2);
i = y_ode45(:,3);
r = 1-s-e-i;

Data = [Time, s, e, i, r];

Ho = abs(X_DFE(1)-s);
Index = find(Ho<0.00001); % Mizane khata dar stady state
if isempty(Index)
    Index = numel(Ho);
end
Index_Steady = Index(1);

%% Find hashiyeh
Ho = abs(i+e-r);
[Error, Index_Threshold] = min(Ho(1:round(Index_Steady/2)));

disp('*********** Hashiyeh ***************')
Threshold = Data(Index_Threshold, :);

Week_Threshold = Threshold(1)
s_Threshold    = Threshold(2)
e_Threshold    = Threshold(3)
i_Threshold    = Threshold(4)
r_Threshold    = Threshold(5)
disp('**************************')
disp('**************************')
disp('************* Stady State *************')
Stady_State = Data(Index_Steady, :);

Week_Stady_State = Stady_State(1)
s_Stady_State    = Stady_State(2)
e_Stady_State    = Stady_State(3)
i_Stady_State    = Stady_State(4)
r_Stady_State    = Stady_State(5)

%% State variables
figure;
plot(Time(1:Index_Steady), s(1:Index_Steady), 'r--', 'LineWidth', 1.5);
hold on
plot(Time(1:Index_Steady), e(1:Index_Steady)+i(1:Index_Steady), 'b-.', 'LineWidth', 1.5);
plot(Time(1:Index_Steady), r(1:Index_Steady), 'g-',  'LineWidth', 2);

plot([Time(Index_Threshold), Time(Index_Threshold)], [0, 1], '--k');
legend('s','e+i', 'r', 'Threshold');

title('SEIR');
xlabel('Time (week)');
ylabel('s, e+i, r');
grid on
set(gca,'Fontweight','Bold', ...
    'FontName','Times New Roman','Fontsize',14);

%% State variables
figure;
plot(Time(1:Index_Steady), e(1:Index_Steady)+i(1:Index_Steady), 'b-.', 'LineWidth', 1.5);
hold on
plot(Time(1:Index_Steady), r(1:Index_Steady), 'g-',  'LineWidth', 2);

plot([Time(Index_Threshold), Time(Index_Threshold)], ...
    [0, r(Index_Threshold)], '--k');
legend('e+i', 'r', 'Threshold');

title('SEIR');
xlabel('Time (week)');
ylabel('e+i, r');
grid on
set(gca,'Fontweight','Bold', ...
    'FontName','Times New Roman','Fontsize',14);
