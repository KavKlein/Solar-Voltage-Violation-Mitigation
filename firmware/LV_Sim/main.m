clear; clc;

cfg = system_config();
cond = conductor_library();

modelName = 'LV_Distribution_Network';
new_system(modelName);
open_system(modelName);

build_model(modelName, cfg, cond);

run_daily_sim(modelName, cfg);

results = voltage_violation_report(modelName, cfg);

pf = recommend_pf(results);

fprintf('Recommended inverter PF: %.3f\n', pf);
