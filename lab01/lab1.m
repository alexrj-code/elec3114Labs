%%-#############################################################
%  ########################    Lab 1    ########################
%--#############################################################
% this is elec3114 lab 1 !!

%%-#############################################################
% Setup 
%--#############################################################

% Table 1-1
R = 1;      % ohms
Km = 5;
B = 20;
J = 1;
L = 1e-3;
Ka = 10;    % min value

s = tf('s');

% the transfer function

G = Km / (s * (J*s + B) * (L*s + R));

% doc tells us

H = 1;

%%-#############################################################
% Q1: Zeros, poles and DC gain
%--#############################################################
G_zeros = zero(G)
G_poles = pole(G)
G_dcgain = dcgain(G)

%%-#############################################################
% Q2: Steped response
%--#############################################################

figure;
step(G, 3);
title('Unit Step Response of G(s)');
ylabel('Amplitude (rad)');
xlabel('Time (seconds)');
grid on;

%%-#############################################################
% Q4: 30 deg question -> how long time
%--#############################################################
[y, t] = step(G, 3);
t_30deg = interp1(y, t, pi/6) % THIS FINDS WITHIN THE STEP Fn



%%-#############################################################
% Q5: Closed loop transfer function
%--#############################################################

% For questions 5 to 9, the following MATLAB commands may be useful: tf, 
% zpk, s = tf('s'), feedback, pole, zero, step, legend.

% Ka1 = 10;

% T = (Ka1*G)/(1+Ka1 * G * H)

% USE PLUGIN INSTEADD

Ka1 = 10;
Ka2 = 19.8;
Ka3 = 40;

% Closed-loop transfer functions using feedback()
T1 = feedback(Ka1*G, H);
T2 = feedback(Ka2*G, H);
T3 = feedback(Ka3*G, H);

%%-#############################################################
% Q6: Compare zeros and poles
%--#############################################################

% Zeros
T1_zeros = zero(T1)
T2_zeros = zero(T2)
T3_zeros = zero(T3)

% Poles
T1_poles = pole(T1)
T2_poles = pole(T2)
T3_poles = pole(T3)

% compare to poles before
G_poles

% plot all the poles

figure;
pzmap(T1, T2, T3);
legend('Ka = 10', 'Ka = 19.8', 'Ka = 40');
grid on;
title('Pole-Zero map for different Ka');


%%-#############################################################
% Q8: Step response for each Ka
%--#############################################################

A = 0.1 % GIVEN IN Q7

figure;
step(A*T1, 2); hold on;
step(A*T2, 2);
step(A*T3, 2);
hold off;

legend('K_a = 10', 'K_a = 19.8', 'K_a = 40');
xlabel('Time (seconds)');
ylabel('Reader Head Position (rad)');
title('Comparison of set-point responses');
grid on;