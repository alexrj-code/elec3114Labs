%%-#############################################################
% Q1a.)  Plant dynamics - Ordinary Differential Equations
%--#############################################################
syms  J_1  J_2  B_1  B_2  K_s  K_m  i_m
syms theta_1  theta_1_D  theta_1_DD
syms theta_2  theta_2_D  theta_2_DD
syms i_m

% Edit these INCORRECT equations ... and make them correct
 % EQ_for_J1 = J_1*theta_1_DD  +  B_1*theta_1_D  +  K_s*theta_2 == 0;
 % EQ_for_J2 = J_2*theta_2_DD  +  B_2*theta_2_D  +  K_s*theta_1 - K_s*theta_2 == K_m*i_m
 
EQ_for_J1 = J_1*theta_1_DD + B_1*theta_1_D + K_s*theta_1 - K_s*theta_2 == K_m*i_m;
EQ_for_J2 = J_2*theta_2_DD + B_2*theta_2_D - K_s*theta_1 + K_s*theta_2 == 0;


%%-#############################################################
% Q1b.)  Plant dynamics - Transfer Functions
%--#############################################################
syms s
num = (K_m * K_s) / (J_1 * J_2);
den = s^4 + ((J_1*B_2 + J_2*B_1)/(J_1*J_2))*s^3 + ...
      ((J_1*K_s + J_2*K_s + B_1*B_2)/(J_1*J_2))*s^2 + ...
      ((B_1*K_s + B_2*K_s)/(J_1*J_2))*s;

G = num / den;

sys_order = 4;



%%-#############################################################
% Q3.)  Quanser robot analysis - State Space model
%--#############################################################
Km = 8.925; %(N.m/A) - Motor #1 torque constant at the harmonic drive #1 shaft output 
Ks = 9; % (N.m/rad) - First Flexible Joint Torsional Stiffness 
J1 = 0.06373091; %(kg.m^2)  - Equivalent Inertia of the loaded drive #1 system 
J2 = 0.23041858; %(kg.m^2) - First Flexible Joint Equivalent Inertia of the complete serial link mechanism downstream
B1 = 4.5; %(N.m.s/rad)  - Equivalent Viscous Damping Coefficient as seen at the drive #1 output shaft 
B2 = 0.070364;  % (N.m.s/rad) - First Flexible Joint (with full load) Equivalent Viscous Damping Coefficient  

%create the state space model
A = [0, 0,  1,  0;
     0, 0,  0,  1;
     -Ks/J1,    Ks/J1,  -B1/J1, 0;
     Ks/J2, -Ks/J2, 0,  -B2/J2];

B = [0; 0; Km/J1; 0];

C = [0, 1, 0, 0];

D = 0;

my_ss_sys = ss(A, B, C, D);


% find eigenvalues
the_model_eigs = eig(my_ss_sys)


% FROM inspection of the eigenvalues, here are the dominant eigenvalues
dom_eig_ss = 0
dom_eig_trans = the_model_eigs(2:3).'
% note: .' = non conjugate trasnpose


% dcgain function works with state space models
the_DC_gain = dcgain(my_ss_sys)



%%-#############################################################
% Q4.)  Converting Transfer Functions into State Space form
%--#############################################################
% find normalised coefficients (a = denom coefficients of s3, s2, s1. b0 = numerator, a0 = constant = 0)
a3_norm = (J1*B2 + J2*B1)/(J1*J2);
a2_norm = (J1*Ks + J2*Ks + B1*B2)/(J1*J2);
a1_norm = (B1*Ks + B2*Ks)/(J1*J2);
a0_norm = 0;
b0_norm = (Km * Ks) / (J1 * J2);

% Technique 1:
Aph = [ 0,  1,  0,  0;...
        0,  0,  1,  0;...
        0,  0,  0,  1;...
       -a0_norm, -a1_norm, -a2_norm, -a3_norm];

Bph = [0; 
       0; 
       0; 
       b0_norm];

Cph = [1, 0, 0, 0];

Dph = 0;

my_ss_ph_sys = ss(Aph, Bph, Cph, Dph);

the_model_eigs_ph = eig(my_ss_ph_sys);


% Technique 2:
G_again = tf([0, 0, 0, 0, b0_norm], [1, a3_norm, a2_norm, a1_norm, a0_norm]);

[G_numer, G_denom] = tfdata(G_again, 'v');

[A1, B1, C1, D1] = tf2ss(G_numer, G_denom);

eigs_of_G = eig(A1)



%%-#############################################################
% Q5.)  Converting State Space form into Transfer Function form
%--#############################################################


% Technique 1:
% G(s) = C(sI - A)^(-1)B + D
s = tf('s');
G1 = C * inv(s*eye(size(A)) - A) * B + D;


% Technique 2:
[G2_numer, G2_denom] = ss2tf(A, B, C, D);
G2 = tf(G2_numer, G2_denom);


%%-#############################################################
% Q6.)  Computing zeros, poles and DC gains of Transfer Functions
%--#############################################################

% G1
p_G1  = pole(G1);
z_G1  = zero(G1);
DC_G1 = dcgain(G1);

%G2
p_G2  = pole(G2);
z_G2  = zero(G2);
DC_G2 = dcgain(G2);

