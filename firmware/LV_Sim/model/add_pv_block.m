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
blk = blkName;  % Return just the block name, not full path

% Model PV as negative load (generator)
% This is a standard approach in distribution system analysis
try
    add_block('powerlib/Elements/Three-Phase Dynamic Load', [model '/' blkName], ...
        'Position',[x y x+80 y+60]);
catch ME
    warning('Failed to add PV block for node %s: %s', node, ME.message);
    hasPV = false;
    return;
end

P = sum(pv.kW) * 1e3;  % W
pf = cfg.solar.pf_fixed;

% Negative P means generation (power flowing into grid)
% Q negative = absorbing reactive power (lagging PF from grid perspective)
Q = P * tan(acos(pf));

% Set parameters: negative active power for generation
% NominalVoltage: [Vn(Vrms) fn(Hz)]
% ActiveReactivePowers: [Po(W) Qo(var)]
set_param([model '/' blkName], ...
    'NominalVoltage', sprintf('[%g %g]', cfg.V_ln_nom, cfg.f_nom), ...
    'ActiveReactivePowers', sprintf('[%g %g]', -P, -Q));  % Negative = generation

hasPV = true;

end