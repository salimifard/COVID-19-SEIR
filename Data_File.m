% Data_File
b = 0.000270925;    % Tavallod (darsad dar week)
d = 8.95472e-05;    % Marg (darsad dar week)

% R: behbood-yafteh
% S: Mostaed
% E: Bimar-bedoone-alamat
% I: Bimar
v     = 0.00;         % Nesbate vacsenasion be tavallod 
Ro    = 0.00;         % Nerkhe vacsenasion afrade bozorgsal (darsad/week)
Alpha = 0.001;        % Nerkhe enteghal az R be S (darsad/week) 
Sigma = 0.070;         % Nerkhe enteghal az E be I (darsad/week) 
Gamma = 0.040;         % Nerkhe enteghal az I be R (darsad/week) 
			
%% Beta
IN = 30280;   % Mavarede bimare jadid nesbat be nemooneh giri ghabli
I = 562000;   % tedade kole bimaran
S = 83e6;  % Afrade mostaed
N = 83e6; % Tedade jameiyate morede barreci
T = 1;     % faselehye zamaniye nemooneha az ham (rooz)
Beta = -log10(1-IN/I)/(T*S/N); % Nerkhe enteghal az S be E (darsad/week) 
Beta = 0.25;

%% Equation for parameters
F = d+Alpha; % Eq (24)

A = Alpha+b*(1-v);  % Eq (19) % Ok
B = b+Ro+Alpha;     % Eq (20) % B = d+Ro+Alpha % Ok
S_STAR = A/B;
C = b+Sigma;        % Eq (21) % C = d+Sigma; % Ok
D = b+Gamma;        % Eq (22) % D = d+Gamma % Ok
