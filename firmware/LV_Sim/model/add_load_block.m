function [blk, hasLoad] = add_load_block(model, node, loadTable, cfg, x, y)

% Initialize return values
blk = '';
hasLoad = false;

% Aggregate load at this pole
svc = loadTable(strcmp(loadTable.PoleID, node), :);

if isempty(svc) || height(svc) == 0
    return;
end

blkName = sprintf('Load_%s', strrep(node, '-', '_'));
blk = blkName;

% Check if block already exists
if ~isempty(find_system(model, 'SearchDepth', 1, 'Name', blkName))
    fprintf('    Load block %s already exists, skipping\n', blkName);
    hasLoad = true;
    return;
end

% CRITICAL FIX: Use Three-Phase Parallel RLC Load instead
% This block supports unbalanced operation better than Dynamic Load
add_block('powerlib/Elements/Three-Phase Parallel RLC Load', [model '/' blkName], ...
    'Position',[x y x+80 y+60]);

% Calculate total load - UNITY POWER FACTOR
P_total = sum(svc.MaxDemand_kW) * 1e3;  % Total watts
pf = cfg.load.pf;  % Should be 1.0

% For unity PF (resistive), we just need active power
% Three-Phase Parallel RLC Load uses per-phase power ratings

% Set parameters - use constant impedance model (most stable)
set_param([model '/' blkName], ...
    'NominalVoltage', num2str(cfg.V_ln_nom), ...
    'NominalFrequency', num2str(cfg.f_nom), ...
    'ActivePower', num2str(P_total/3), ...  % Divide by 3 for per-phase
    'InductivePower', '0', ...              % Unity PF
    'CapacitivePower', '0', ...
    'LoadType', 'constant Z');

hasLoad = true;

end