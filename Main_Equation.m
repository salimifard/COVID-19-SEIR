clc;
clear
close all;
drawnow;

%% Equation
syms b d v Ro Alpha Beta Sigma Gamma s e i t posetive
syms A B C D F Landa

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
X_EE  = [s_star(1); e_star(1); i_star(1)] % Eq (26)
X_DFE = [s_star(2); e_star(2); i_star(2)] % Eq (25)
disp('***************************************************');

%% Jacobian EE & DFE
J = [
    diff(G,s),diff(G,e),diff(G,i);
    diff(H,s),diff(H,e),diff(H,i);
    diff(K,s),diff(K,e),diff(K,i)] % Eq (28)

J_EE  = subs(J, X, X_EE)
J_DFE = subs(J, X, X_DFE) % Eq (33)
disp('***************************************************');

Landa_DFE = eig(J_DFE) % Eq (34)
disp('***************************************************');
Landa_EE  = eig(J_EE)  % Eq (73)
