function [loadTable, solarTable] = generate_connections(net, cfg)

rng(cfg.random_seed);

poles = net.poleTable;
nPoles = height(poles);

nLoads = net.total_services;

loadTypes = strings(nLoads,1);
loadkVA   = zeros(nLoads,1);
loadkW    = zeros(nLoads,1);
loadPhase = strings(nLoads,1);
poleID = randsample(poles.PoleID, nLoads, true);

% cumulative probabilities
p1 = cfg.load.ratio_1ph_30A;
p2 = p1 + cfg.load.ratio_1ph_60A;
% remaining = 3ph

for i = 1:nLoads
    r = rand;

    if r < p1
        loadTypes(i) = "1ph_30A";
        loadkVA(i)   = 7;
        loadkW(i)    = cfg.load.kW_1ph_30A;
        loadPhase(i) = random_phase();

    elseif r < p2
        loadTypes(i) = "1ph_60A";
        loadkVA(i)   = 14;
        loadkW(i)    = cfg.load.kW_1ph_60A;
        loadPhase(i) = random_phase();

    else
        loadTypes(i) = "3ph_60A";
        loadkVA(i)   = 42;
        loadkW(i)    = cfg.load.kW_3ph_60A;
        loadPhase(i) = "ABC";
    end
end

loadTable = table( ...
    poleID, loadTypes, loadkVA, loadkW, loadPhase, ...
    'VariableNames', {'PoleID','Type','kVA','kW','Phase'});

% SOLAR GENERATION
nSolarSites = round(net.total_services * cfg.solar.penetration_ratio);

% Pre-allocate ALL arrays with correct size
solarPoleID = strings(nSolarSites, 1);  % Make sure it's a column vector
invSizes    = zeros(nSolarSites, 1);    % Initialize as column vector
solarType   = strings(nSolarSites, 1);
solarPhase  = strings(nSolarSites, 1);

% Sample pole IDs
tempPoles = randsample(poles.PoleID, nSolarSites, true);
solarPoleID(:) = tempPoles;  % Assign to pre-allocated array

% Sample inverter sizes
tempSizes = randsample(cfg.solar.inv_sizes_kW, ...
                       nSolarSites, true, cfg.solar.inv_size_prob);
invSizes(:) = tempSizes;  % Assign to pre-allocated array

% Determine phase configuration for each solar site
for i = 1:nSolarSites
    if invSizes(i) > cfg.solar.force_3ph_above_kW
        solarType(i)  = "3ph";
        solarPhase(i) = "ABC";
    else
        solarType(i)  = "1ph";
        solarPhase(i) = random_phase();
    end
end

% Verify all arrays have same length before creating table
fprintf('Debug: nSolarSites = %d\n', nSolarSites);
fprintf('Debug: length(solarPoleID) = %d\n', length(solarPoleID));
fprintf('Debug: length(invSizes) = %d\n', length(invSizes));
fprintf('Debug: length(solarType) = %d\n', length(solarType));
fprintf('Debug: length(solarPhase) = %d\n', length(solarPhase));

% Create solar table
solarTable = table( ...
    solarPoleID, invSizes, solarType, solarPhase, ...
    'VariableNames', {'PoleID','kW','Type','Phase'});
%outputs
disp('LOAD DISTRIBUTION (kW)')
disp(groupsummary(loadTable,'Type','sum','kW'))

disp('SOLAR DISTRIBUTION (kW)')
disp(groupsummary(solarTable,'Type','sum','kW'))

writetable(loadTable,  'outputs/load_assignment.csv');
writetable(solarTable, 'outputs/solar_assignment.csv');

end

function ph = random_phase()
ph = ["A","B","C"];
ph = ph(randi(3));
end