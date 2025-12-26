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

% BEST SOLUTION: Use Three-Phase Dynamic Load for PV (as before)
% But loads now use RLC Load (impedance model) so no conflict
try
    add_block('powerlib/Elements/Three-Phase Dynamic Load', [model '/' blkName], ...
        'Position',[x y x+80 y+60]);
catch ME
    warning('Failed to add PV block for node %s: %s', node, ME.message);
    hasPV = false;
    return;
end

P_total = sum(pv.kW) * 1e3;  % W
pf = cfg.solar.pf_fixed;  % 0.95 inverter PF

% For generator (negative load), calculate reactive power
Q_total = P_total * tan(acos(pf));

% Set parameters: NEGATIVE active power = generation
set_param([model '/' blkName], ...
    'NominalVoltage', sprintf('[%g %g]', cfg.V_ln_nom, cfg.f_nom), ...
    'ActiveReactivePowers', sprintf('[%g %g]', -P_total, -Q_total), ...
    'NpNq', '[1 0]');

hasPV = true;

end