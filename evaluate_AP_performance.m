function results = evaluate_AP_performance(G_true, I_cont)

%% Extract data from Simulink timeseries

time = G_true.Time;
glucose = G_true.Data;

insulin_time = I_cont.Time;
insulin = I_cont.Data;


%% Convert to column vectors

time = time(:);
glucose = glucose(:);

insulin_time = insulin_time(:);
insulin = insulin(:);


%% Check lengths

if length(time) ~= length(glucose)
    error('Glucose time and glucose data must have the same length.');
end

if length(insulin_time) ~= length(insulin)
    error('Insulin time and insulin data must have the same length.');
end


%% Parameters

G_ref = 5.0;       % Reference glucose [mmol/L]

G_lower = 3.9;     % Lower target limit [mmol/L]

G_upper = 10.0;    % Upper target limit [mmol/L]


%% 1. TIME IN RANGE

in_range = (glucose >= G_lower) & ...
           (glucose <= G_upper);

TIR = sum(in_range) / length(glucose) * 100;


%% 2. TIME ABOVE RANGE

above_range = glucose > G_upper;

TAR = sum(above_range) / length(glucose) * 100;


%% 3. TIME BELOW RANGE

below_range = glucose < G_lower;

TBR = sum(below_range) / length(glucose) * 100;


%% 4. PEAK GLUCOSE

[peak_glucose, peak_index] = max(glucose);

time_to_peak = time(peak_index);


%% 5. MAXIMUM OVERSHOOT

maximum_overshoot = max(0, peak_glucose - G_ref);

maximum_overshoot_percent = ...
    (maximum_overshoot / G_ref) * 100;


%% 6. SETTLING TIME

% Settling band = +/- 5% of reference

settling_tolerance = 0.05 * G_ref;

upper_limit = G_ref + settling_tolerance;
lower_limit = G_ref - settling_tolerance;

within_band = ...
    (glucose >= lower_limit) & ...
    (glucose <= upper_limit);


% Find samples outside settling band

outside_band = find(~within_band);


if isempty(outside_band)

    settling_time = 0;

elseif outside_band(end) == length(glucose)

    settling_time = NaN;

else

    settling_time = time(outside_band(end) + 1);

end


%% 7. STEADY-STATE ERROR

final_glucose = glucose(end);

steady_state_error = abs(final_glucose - G_ref);


%% 8. TOTAL INSULIN DELIVERED

% Interpolate insulin onto glucose time vector

insulin_interp = interp1( ...
    insulin_time, ...
    insulin, ...
    time, ...
    'linear', ...
    'extrap');


% Prevent negative insulin values

insulin_interp(insulin_interp < 0) = 0;


% I_cont is assumed to be in mU/min
%
% Integrating over minutes gives mU

total_insulin_mU = trapz(time, insulin_interp);


% Convert mU to U

total_insulin_U = total_insulin_mU / 1000;


%% STORE RESULTS

results.TIR = TIR;

results.TAR = TAR;

results.TBR = TBR;

results.peak_glucose = peak_glucose;

results.maximum_overshoot = maximum_overshoot;

results.maximum_overshoot_percent = ...
    maximum_overshoot_percent;

results.time_to_peak = time_to_peak;

results.settling_time = settling_time;

results.final_glucose = final_glucose;

results.steady_state_error = steady_state_error;

results.total_insulin_U = total_insulin_U;


%% DISPLAY RESULTS

fprintf('\n');
fprintf('=============================================\n');
fprintf(' ARTIFICIAL PANCREAS PERFORMANCE EVALUATION\n');
fprintf('=============================================\n');

fprintf('\n');

fprintf('Reference Glucose       : %.2f mmol/L\n', G_ref);

fprintf('Target Range            : %.1f - %.1f mmol/L\n', ...
    G_lower, G_upper);


fprintf('\n');
fprintf('GLYCAEMIC CONTROL\n');
fprintf('---------------------------------------------\n');

fprintf('Time in Range (TIR)     : %.2f %%\n', TIR);

fprintf('Time Above Range (TAR)  : %.2f %%\n', TAR);

fprintf('Time Below Range (TBR)  : %.2f %%\n', TBR);


fprintf('\n');
fprintf('TRANSIENT RESPONSE\n');
fprintf('---------------------------------------------\n');

fprintf('Peak Glucose            : %.2f mmol/L\n', ...
    peak_glucose);

fprintf('Maximum Overshoot       : %.2f mmol/L\n', ...
    maximum_overshoot);

fprintf('Overshoot               : %.2f %%\n', ...
    maximum_overshoot_percent);

fprintf('Time to Peak            : %.2f min\n', ...
    time_to_peak);


if isnan(settling_time)

    fprintf('Settling Time           : Not reached\n');

else

    fprintf('Settling Time           : %.2f min\n', ...
        settling_time);

end


fprintf('\n');
fprintf('STEADY-STATE PERFORMANCE\n');
fprintf('---------------------------------------------\n');

fprintf('Final Glucose           : %.2f mmol/L\n', ...
    final_glucose);

fprintf('Steady-State Error      : %.4f mmol/L\n', ...
    steady_state_error);


fprintf('\n');
fprintf('INSULIN DELIVERY\n');
fprintf('---------------------------------------------\n');

fprintf('Total Insulin Delivered : %.4f U\n', ...
    total_insulin_U);


fprintf('\n');
fprintf('=============================================\n');

end