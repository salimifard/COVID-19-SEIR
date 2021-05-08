function dy=Myfun(t,y)
% Load data
Data_File;

%% State Variables
s  = y(1);
e  = y(2);
i  = y(3);
%r  = 1-s-e-i; % Eq (16)

%% Equations
% N = exp((b-d)*t); % Eq (8)

% S = s*N; % Eq (9)
% E = e*N; % Eq (10)
% I = i*N; % Eq (11)
% R = r*N; % Eq (12)

d_s = A-Alpha*e-Alpha*i-Beta*s*i-B*s; % Eq (18)
d_e = Beta*s*i-C*e;                   % Eq (18)
d_i = Sigma*e-D*i;                    % Eq (18)
%d_r = b*v+Gamma*i+Ro*s-F*r;           % Eq (23)

dy = [d_s; d_e; d_i];

