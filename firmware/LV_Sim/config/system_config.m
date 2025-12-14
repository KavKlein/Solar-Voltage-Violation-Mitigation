function cfg = system_config()

cfg.f_nom = 50;                 % Hz
cfg.V_ln_nom = 230;             % V
cfg.V_ll_nom = 415;             % V
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


% Simulation
cfg.T_sim = 24*3600;
cfg.dt = 60; % 1 min
cfg.solver = 'ode23tb';

end
