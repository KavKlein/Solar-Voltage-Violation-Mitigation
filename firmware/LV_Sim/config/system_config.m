function cfg = system_config()

% ==================== SYSTEM PARAMETERS ====================
cfg.f_nom = 50;                 % Hz
cfg.V_ln_nom = 230;             % V (line-to-neutral)
cfg.V_ll_nom = 400;             % V (line-to-line)
cfg.voltage_limits = [0.94 1.06]; % ±6%

% ==================== TRANSFORMER ====================
cfg.tf.rating_kVA = 160;
cfg.tf.V_HV = 11e3;
cfg.tf.V_LV = 415;
cfg.tf.connection = 'Dyn11';
cfg.tf.Z_pu = 0.0414;
cfg.tf.XR = 5;
cfg.tf.tap_positions = [-5 -2.5 0 2.5 5]; % %
cfg.tf.tap_index = 3; % 0% (nominal)

% ==================== LOAD PARAMETERS ====================
% Service type ratios (BY COUNT)
cfg.load.ratio_1ph_30A = 0.60;  % 60% of services
cfg.load.ratio_1ph_60A = 0.30;  % 30% of services
cfg.load.ratio_3ph_60A = 0.10;  % 10% of services

% Maximum demand per service type (kW)
cfg.load.demand_1ph_30A = 2.5;  % 30A × 230V × PF / 1000
cfg.load.demand_1ph_60A = 4.5;  % 60A × 230V × PF / 1000
cfg.load.demand_3ph_60A = 9.0;  % 60A × 400V × PF / 1000

% POWER FACTOR (CRITICAL CORRECTION)
cfg.load.pf = 1.0;              % Unity PF (resistive loads)

% DIVERSITY AND COINCIDENCE FACTORS
cfg.load.diversity_factor = 1.0;     % Set to 1 for now (ideal case)
cfg.load.coincidence_factor = 0.35;  % Realistic for Sri Lankan residential
                                     % (35% of services at peak simultaneously)

% ==================== SOLAR PV PARAMETERS ====================
% SOLAR PENETRATION (CRITICAL CORRECTION)
% Penetration is % of TOTAL LOAD, not % of connections
cfg.solar.penetration_min = 0.70;   % 70% of total load
cfg.solar.penetration_max = 0.80;   % 80% of total load

% Inverter size distribution (BY COUNT of installations)
cfg.solar.inv_sizes_kW  = [3 5 7 10 15];
cfg.solar.inv_size_prob = [0.35 0.30 0.20 0.10 0.05];

% Phase connection rule
cfg.solar.force_3ph_above_kW = 12;   % >12kW must be 3ph

% INVERTER POWER FACTOR (CRITICAL CORRECTION)
cfg.solar.pf_fixed = 0.95;          % Inverter operates at 0.95 PF

% ==================== SIMULATION PARAMETERS ====================
cfg.T_sim = 24*3600;    % 24 hours
cfg.dt = 60;            % 1 minute timestep
cfg.solver = 'ode23tb';
cfg.random_seed = 1;    % For reproducibility

end