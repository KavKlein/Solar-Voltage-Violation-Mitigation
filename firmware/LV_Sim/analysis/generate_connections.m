function [loadTable, solarTable] = generate_connections(net, cfg)

rng(cfg.random_seed);

poles = net.poleTable;
nPoles = height(poles);
nServices = net.total_services;

fprintf('\n========== LOAD ASSIGNMENT ==========\n');

% ==================== STEP 1: ASSIGN LOAD TYPES ====================
loadTypes = strings(nServices, 1);
maxDemand_kW = zeros(nServices, 1);
loadPhase = strings(nServices, 1);
poleID = randsample(poles.PoleID, nServices, true);

p1 = cfg.load.ratio_1ph_30A;
p2 = p1 + cfg.load.ratio_1ph_60A;

for i = 1:nServices
    r = rand;
    if r < p1
        loadTypes(i) = "1ph_30A";
        maxDemand_kW(i) = cfg.load.demand_1ph_30A;
        loadPhase(i) = random_phase();
    elseif r < p2
        loadTypes(i) = "1ph_60A";
        maxDemand_kW(i) = cfg.load.demand_1ph_60A;
        loadPhase(i) = random_phase();
    else
        loadTypes(i) = "3ph_60A";
        maxDemand_kW(i) = cfg.load.demand_3ph_60A;
        loadPhase(i) = "ABC";
    end
end

% ==================== STEP 2: CALCULATE TOTAL LOAD ====================
total_max_demand = sum(maxDemand_kW);
coincident_demand = total_max_demand * cfg.load.coincidence_factor;
diversified_demand = coincident_demand * cfg.load.diversity_factor;

fprintf('Total services: %d\n', nServices);
fprintf('Total max demand (sum of all): %.1f kW\n', total_max_demand);
fprintf('Coincident demand (×%.2f): %.1f kW\n', cfg.load.coincidence_factor, coincident_demand);
fprintf('Diversified demand (×%.2f): %.1f kW\n', cfg.load.diversity_factor, diversified_demand);
fprintf('Transformer rating: %.1f kVA\n', cfg.tf.rating_kVA);

% Check if load exceeds transformer
if diversified_demand > cfg.tf.rating_kVA * cfg.load.pf
    warning('Diversified demand (%.1f kW) exceeds transformer capacity!', diversified_demand);
end

loadTable = table(poleID, loadTypes, maxDemand_kW, loadPhase, ...
    'VariableNames', {'PoleID','Type','MaxDemand_kW','Phase'});

fprintf('\n========== SOLAR ASSIGNMENT ==========\n');

% ==================== STEP 3: CALCULATE REQUIRED SOLAR CAPACITY ====================
% Solar penetration is % of TOTAL LOAD (not % of connections)
target_solar_min = diversified_demand * cfg.solar.penetration_min;
target_solar_max = diversified_demand * cfg.solar.penetration_max;

fprintf('Target solar capacity: %.1f - %.1f kW (%.0f%% - %.0f%% of load)\n', ...
    target_solar_min, target_solar_max, ...
    cfg.solar.penetration_min*100, cfg.solar.penetration_max*100);

% ==================== STEP 4: GENERATE SOLAR INSTALLATIONS ====================
% Iteratively add solar systems until we reach target range
solarPoleID = [];
invSizes_kW = [];
solarType = [];
solarPhase = [];
currentSolarTotal = 0;

while currentSolarTotal < target_solar_min
    % Sample one inverter size
    inv_kW = randsample(cfg.solar.inv_sizes_kW, 1, true, cfg.solar.inv_size_prob);
    
    % Don't overshoot max limit too much
    if currentSolarTotal + inv_kW > target_solar_max * 1.1
        % Try smaller size
        smaller_sizes = cfg.solar.inv_sizes_kW(cfg.solar.inv_sizes_kW <= inv_kW);
        if ~isempty(smaller_sizes)
            inv_kW = smaller_sizes(end);
        end
    end
    
    % Assign to random pole
    pole = randsample(poles.PoleID, 1);
    
    % Determine phase configuration
    if inv_kW > cfg.solar.force_3ph_above_kW
        type = "3ph";
        phase = "ABC";
    else
        type = "1ph";
        phase = random_phase();
    end
    
    % Add to arrays
    solarPoleID = [solarPoleID; pole];
    invSizes_kW = [invSizes_kW; inv_kW];
    solarType = [solarType; type];
    solarPhase = [solarPhase; phase];
    
    currentSolarTotal = currentSolarTotal + inv_kW;
end

fprintf('Generated %d solar installations\n', length(invSizes_kW));
fprintf('Total solar capacity: %.1f kW (%.1f%% of load)\n', ...
    currentSolarTotal, (currentSolarTotal/diversified_demand)*100);

solarTable = table(solarPoleID, invSizes_kW, solarType, solarPhase, ...
    'VariableNames', {'PoleID','kW','Type','Phase'});

% ==================== DISPLAY SUMMARY ====================
fprintf('\n========== SUMMARY ==========\n');
disp('LOAD DISTRIBUTION:');
disp(groupsummary(loadTable, 'Type', 'sum', 'MaxDemand_kW'));

fprintf('\nSOLAR DISTRIBUTION:\n');
disp(groupsummary(solarTable, 'Type', 'sum', 'kW'));

fprintf('\nLOAD vs SOLAR:\n');
fprintf('  Diversified Load: %.1f kW\n', diversified_demand);
fprintf('  Solar Capacity:   %.1f kW\n', currentSolarTotal);
fprintf('  Solar/Load Ratio: %.1f%%\n', (currentSolarTotal/diversified_demand)*100);

% Save outputs
if ~exist('outputs', 'dir')
    mkdir('outputs');
end
writetable(loadTable, 'outputs/load_assignment.csv');
writetable(solarTable, 'outputs/solar_assignment.csv');

end

function ph = random_phase()
    phases = ["A", "B", "C"];
    ph = phases(randi(3));
end