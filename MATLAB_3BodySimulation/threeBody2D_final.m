close all;
clear all;

%% Initial variables
%{
G = Gravitational Constant
m1, m2, m3 = mass (in kg) of first, second and third object respectively.
R1, R2, R3 = positions of masses
v1, v2, v3 = velocities (in ms^-1) of the masses
a1, a2, a3 = accelerations (in ms^-2) of the masses
%}

global G
global m1
global m2
global m3

G = 6.6743E-11;
m1 = 10E+16;
m2 = 10E+16;
m3 = 10E+16;
M = m1 + m2 + m3;       

R1i = [0 0];                        % initial conditions
R2i = [1000 1000];
R3i = [-1000 -1000];
v1i = [0 1];
v2i = [20 0];
v3i = [0 40];
 
y0 = [R1i R2i R3i v1i v2i v3i];     % initial state vector

tspan = 0:0.1:50;                                      % time span of the simulation
options = odeset('RelTol', 1e-6, 'AbsTol', 1e-8);    % sets integration tolerances to avoid singularities
[t,y] = ode45(@motion, tspan, y0, options);            % this solves the set of ODEs in the motion function over tspan for state vector y0

R1f = y(:, 1:2);                                % final positions
R2f = y(:, 3:4);
R3f = y(:, 5:6);
Rcom = (m1.*R1f + m2.*R2f + m3.*R3f)./M;        % centre of mass

Rcom1 = vecnorm(R1f - Rcom, 2, 2);              % distance from centre of mass to each object
Rcom2 = vecnorm(R2f - Rcom, 2, 2);
Rcom3 = vecnorm(R3f - Rcom, 2, 2);

figure('visible','off');                        % the Rcom(1,2,3) distances are recorded over each timestep
plot(t, Rcom1, t, Rcom2, t, Rcom3);
                       
f = figure;                           % create a new figure
f.Position(1:2) = [170 140];          % figure size config
f.Position(3:4) = [840 630];

for i = 1:length(t)
   
    h = plot(R1f(i,1), R1f(i,2),'o', R2f(i,1), R2f(i,2),'o', R3f(i,1), R3f(i,2),'o', Rcom(i,1), Rcom(i,2),'x');  % plot new positions of the three masses and COM
    grid on;
    xlim([-3000 3000]);                                                                                          % set x,y axis limits
    ylim([-3000 3000]);                                         
    title(sprintf('Time: %0.2f', t(i)));                                                                         % displays time in title
    pause(0.01);                                                                                                 % displays motion of three bodies over time
    
end

%% Acceleration Calculation
function dydt = motion(~,y)

    global G
    global m1
    global m2
    global m3
   
    R1 = y(1:2);             % define position components in state vector y                
    R2 = y(3:4);
    R3 = y(5:6);

    v1 = y(7:8);             % define velocity components in state vector y
    v2 = y(9:10);
    v3 = y(11:12);

    r12 = norm(R1-R2);       % distances between each object
    r13 = norm(R1-R3);
    r21 = norm(R2-R1);
    r23 = norm(R2-R3);
    r31 = norm(R3-R1);
    r32 = norm(R3-R2);  

    a1 = -G.*m2.*(R1-R2)./r12.^3-G*m3.*(R1-R3)./r13.^3;      % acceleration derived from F = ma for both masses
    a2 = -G.*m3.*(R2-R3)./r23.^3-G.*m1.*(R2-R1)./r21.^3;
    a3 = -G.*m1.*(R3-R1)./r31.^3-G.*m2.*(R3-R2)./r32.^3;
   
    dydt = [v1; v2; v3; a1; a2; a3];        % change in velocities over time
    end