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
add_block('ee_lib/Passive/Constant Power Load (Three-Phase)', ...
    [model '/' blkName], ...
    'Position',[x y x+90 y+60]);


% Calculate total load - UNITY POWER FACTOR
P = sum(svc.MaxDemand_kW) * 1e3;  % Total watts

% For unity PF (resistive), we just need active power
% Three-Phase Parallel RLC Load uses per-phase power ratings

% Set parameters - use constant impedance model (most stable)
set_param([model '/' blkName], ...
    'LoadType', 'constant Z', ...
    'Vline_rms_ini', num2str(cfg.V_ln_nom*sqrt(3,3)), ...
    'FRated', num2str(cfg.f_nom), ...
    'active_power', num2str(P/3));  % Per phase

hasLoad = true;

end