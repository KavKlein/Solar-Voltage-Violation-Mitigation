function [blk, hasPV] = add_pv_block(model, node, solarTable, cfg, x, y)

% Initialize return values
blk = '';
hasPV = false;

% Filter solar sites for this pole
pv = solarTable(strcmp(solarTable.PoleID, node), :);

% Debug
fprintf('    Checking PV for pole %s: found %d solar sites\n', node, height(pv));

% Only add PV block if there's solar at this pole
if isempty(pv) || height(pv) == 0
    return; 
end

blkName = sprintf('PV_%s', strrep(node, '-', '_'));
blk = blkName;

% Check if block already exists
if ~isempty(find_system(model, 'SearchDepth', 1, 'Name', blkName))
    fprintf('    PV block %s already exists, skipping\n', blkName);
    hasPV = true;
    return;
end

add_block('ee_lib/Sources/Controlled Current Source (Three-Phase)', ...
    [model '/' blkName], ...
    'Position',[x y x+100 y+60]);

P = sum(pv.kW)*1e3;
Q = P*tan(acos(cfg.solar.pf_fixed));

% Calculate voltage and current for constant power injection
% Voltage matches grid, current adjusted for power
V_source = cfg.V_ln_nom;  % Match grid voltage

% Set as constant PQ source (inverter behavior)
set_param([model '/' blkName], ...
    'input_option', 'Sinusoidal magnitude and phase shift', ...
    'FRated', num2str(cfg.f_nom));  % Inverter absorbs reactive

hasPV = true;

end