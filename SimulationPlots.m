%Extract Simulation Data

% Closed-loop glucose
t_G = G_true.Time;
G   = G_true.Data;

% Open-loop glucose
t_G1 = G_true1.Time;
G1   = G_true1.Data;

% Plasma insulin
t_I = I_true.Time;
I   = I_true.Data;

% Remote insulin action
t_X = X_true.Time;
X   = X_true.Data;

% Meal disturbance
t_D = D_true.Time;
D   = D_true.Data;

% Controller insulin input
t_Icont = I_cont.Time;
Icont   = I_cont.Data;


figure;
subplot(2,1,1);

% LEFT Y-AXIS: GLUCOSE
yyaxis left

% Closed-loop glucose - solid blue
plot(t_G, G, 'b-', 'LineWidth', 1.5);
hold on;

% Open-loop glucose - dashed blue
plot(t_G1, G1, 'b--', 'LineWidth', 1.5);

% Glucose thresholds - dotted blue
yline(10, 'b:', 'LineWidth', 1.2);
yline(3.9, 'b:', 'LineWidth', 1.2);

ylabel('Glucose Concentration (mmol/L)');

% Set glucose axis based on both responses
ylim([0 max([G(:); G1(:)]) * 1.1]);


% RIGHT Y-AXIS: MEAL DISTURBANCE
yyaxis right

% Meal disturbance - solid red
plot(t_D, D, 'r-', 'LineWidth', 1.5);

ylabel('D(t) (mmol/L/min)');

title('Glucose Response and Meal Disturbance');

grid on;

legend('Closed-loop glucose', ...
       'Open-loop glucose', ...
       '', ...
       '', ...
       'Meal disturbance', ...
       'Location', 'best');

hold off;

subplot(2,1,2);

% LEFT Y-AXIS: PLASMA INSULIN
yyaxis left

% Plasma insulin - solid blue
plot(t_I, I, 'b-', 'LineWidth', 1.5);
hold on;

ylabel('Plasma Insulin (\muU/mL)');


% RIGHT Y-AXIS: CONTROLLER INPUT
yyaxis right

% Controller insulin input - dashed red
plot(t_Icont, Icont, 'r--', 'LineWidth', 1.5);

ylabel('Input (\muU/mL/min)');

xlabel('Time (min)');

title('Insulin Dynamics and Controller Input');

grid on;

legend('Plasma insulin', ...
       'Insulin control input', ...
       'Location', 'best');

hold off;

results = evaluate_AP_performance(G_true, I_cont);

% % Extract Simulation Data
% 
% % Patient 1
% t_P1 = patient1.Time;
% P1   = patient1.Data;
% 
% % Patient 2
% t_P2 = patient2.Time;
% P2   = patient2.Data;
% 
% % Patient 3
% t_P3 = patient3.Time;
% P3   = patient3.Data;
% 
% % Patient 4
% t_P4 = patient4.Time;
% P4   = patient4.Data;
% 
% % Meal disturbance
% t_D = D_true.Time;
% D   = D_true.Data;
% 
% 
% %% Combined Figure: Patient Glucose and Insulin Responses
% 
% figure;
% 
% 
% %% ========================================================
% % SUBPLOT 1: GLUCOSE RESPONSES AND MEAL DISTURBANCE
% % =========================================================
% 
% subplot(2,1,1);
% 
% % LEFT Y-AXIS: GLUCOSE
% 
% yyaxis left
% 
% hold on;
% 
% % Patient 1 - solid blue
% plot(t_P1, P1(:,3), 'b-', 'LineWidth', 1.5);
% 
% % Patient 2 - solid red
% plot(t_P2, P2(:,3), 'r-', 'LineWidth', 1.5);
% 
% % Patient 3 - solid green
% plot(t_P3, P3(:,3), 'g-', 'LineWidth', 1.5);
% 
% % Patient 4 - solid black
% plot(t_P4, P4(:,3), 'k-', 'LineWidth', 1.5);
% 
% % Glucose thresholds
% yline(10, 'b:', 'LineWidth', 1.2);
% yline(3.9, 'b:', 'LineWidth', 1.2);
% 
% ylabel('Glucose Concentration (mmol/L)');
% 
% % Set glucose axis based on all four patients
% ylim([0 max([P1(:,3); P2(:,3); P3(:,3); P4(:,3)]) * 1.1]);
% 
% 
% % RIGHT Y-AXIS: MEAL DISTURBANCE
% 
% yyaxis right
% 
% plot(t_D, D, 'm-', 'LineWidth', 1.5);
% 
% ylabel('D(t) (mmol/L/min)');
% 
% xlabel('Time (min)');
% 
% title('Glucose Response of Patients and Meal Disturbance');
% 
% grid on;
% 
% legend('Patient 1', ...
%        'Patient 2', ...
%        'Patient 3', ...
%        'Patient 4', ...
%        '', ...
%        '', ...
%        'Meal disturbance', ...
%        'Location', 'best');
% 
% hold off;
% 
% 
% %% ========================================================
% % SUBPLOT 2: PLASMA INSULIN CONCENTRATION
% % =========================================================
% 
% subplot(2,1,2);
% 
% yyaxis left
% 
% hold on;
% 
% % Patient 1 - solid blue
% plot(t_P1, P1(:,2), 'b-', 'LineWidth', 1.5);
% 
% % Patient 2 - solid red
% plot(t_P2, P2(:,2), 'r-', 'LineWidth', 1.5);
% 
% % Patient 3 - solid green
% plot(t_P3, P3(:,2), 'g-', 'LineWidth', 1.5);
% 
% % Patient 4 - solid black
% plot(t_P4, P4(:,2), 'k-', 'LineWidth', 1.5);
% 
% ylabel('Plasma Insulin (\muU/mL)');
% 
% xlabel('Time (min)');
% 
% title('Plasma Insulin Concentration');
% 
% grid on;
% 
% legend('Patient 1', ...
%        'Patient 2', ...
%        'Patient 3', ...
%        'Patient 4', ...
%        'Location', 'best');
% 
% hold off;