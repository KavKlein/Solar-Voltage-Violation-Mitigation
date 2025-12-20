function cfg = system_config()

cfg.f_nom = 50;                 % Hz
cfg.V_ln_nom = 230;             % V
cfg.V_ll_nom = 400;             % V
cfg.voltage_limits = [0.94 1.06]; % ±6%

% Transformer
cfg.tf.rating_kVA = 160;
cfg.tf.V_HV = 11e3;
cfg.tf.V_LV = 415;
cfg.tf.connection = 'Dyn11';
cfg.tf.Z_pu = 0.0414;
cfg.tf.XR = 5;
cfg.tf.tap_positions = [-5 -2.5 0 2.5 5]; % %
cfg.tf.tap_index = 2; % -2.5%

cfg.load.avg_kW = 3.5;
cfg.load.pf     = 0.9;
cfg.pv.pf_fixed = 0.95;

%++++++++++++++++++++++++load assumptions+++++++++++++++++++++++++++++++

% Service type ratios (BY COUNT)
cfg.load.ratio_1ph_30A = 0.60;
cfg.load.ratio_1ph_60A = 0.30;
cfg.load.ratio_3ph_60A = 0.10;

% Typical demand per service
cfg.load.kW_1ph_30A = 2.5;
cfg.load.kW_1ph_60A = 4.5;
cfg.load.kW_3ph_60A = 9.0;

cfg.load.pf_1ph = 0.90;
cfg.load.pf_3ph = 0.92;

%++++++++++++++++++++++++solar assumptions++++++++++++++++++++++++++++++

% Inverter size distribution (BY COUNT)
cfg.solar.inv_sizes_kW  = [5 10 15 20 40];
cfg.solar.inv_size_prob = [0.40 0.35 0.15 0.07 0.03];

% Phase connection rule
cfg.solar.force_3ph_above_kW = 12;   % >12kW must be 3ph

% Desired phase split (BY kW, soft constraint)
cfg.solar.target_3ph_kW_ratio = 0.45;   % ~45% of PV kW is 3ph
cfg.solar.target_1ph_kW_ratio = 0.55;

% Electrical behaviour
cfg.solar.pf_fixed = 0.95;

% --- Solar penetration (BY SERVICE COUNT) ---
cfg.solar.penetration_ratio = 0.70;   % 70% of services have PV


% Simulation
cfg.T_sim = 24*3600;
cfg.dt = 60; % 1 min
cfg.solver = 'ode23tb';

%values
cfg.random_seed = 1;


end
