clear; clc;

cfg = system_config();

modelName = 'LV_Distribution_Network';

% Check if model exists and close/delete it
if bdIsLoaded(modelName)
    close_system(modelName, 0);
end
if exist([modelName '.slx'], 'file')
    delete([modelName '.slx']);
end

new_system(modelName);
open_system(modelName);

net = read_network_data('data/LV_Network_Data.xlsx');

[loadTable, solarTable] = generate_connections(net, cfg);

% FIX: Pass conductor parameter to build_model
build_model(modelName, net, cfg, loadTable, solarTable);

run_daily_sim(modelName, cfg);

results = voltage_violation_report(modelName, cfg);

pf = recommend_pf(results);

fprintf('Recommended inverter PF: %.3f\n', pf);