clc;
clear
close all;
drawnow;

%% Load Data
Data_File;

%% Equation
syms s e i t posetive
syms Landa

X = [s; e; i];

r  = 1-s-e-i; % Eq (16)

N = exp((b-d)*t); % Eq (8)

S = s*N; % Eq (9)
E = e*N; % Eq (10)
I = i*N; % Eq (11)
R = r*N; % Eq (12)

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

X_DFE
X_EE

%% Jacobian EE & DFE
J = [
    diff(G,s),diff(G,e),diff(G,i);
    diff(H,s),diff(H,e),diff(H,i);
    diff(K,s),diff(K,e),diff(K,i)]; % Eq (28)

J_EE  = double(subs(J, X, X_EE))
J_DFE = double(subs(J, X, X_DFE)) % Eq (33)
disp('***************************************************');

Landa_EE = solve(det(J_EE-Landa*eye(3))==0, Landa); % Eq (73)
Landa_EE = double(Landa_EE)

disp('***************************************************')

Landa_DFE = solve(det(J_DFE-Landa*eye(3))==0, Landa); % Eq (34)
Landa_DFE = double(Landa_DFE)

%% New equation
R0  = Beta*Sigma*A/(B*C*D)% 71
ESR = Beta/Gamma

W = [Landa_DFE; Landa_EE]; % vector of eigen values
N = 3;
Am = [
    1 1 1
    0 1 1
    0 0 1];
Dm = [
    1 0 0
    0 2 0
    0 0 3];

M = [
    Am,      eye(N)-Dm
    ones(N), zeros(N)];

Lambda_M = max(W.'*M*W/(W.'*W))
ET_DMP = 1/Lambda_M