function [blk, hasLoad] = add_load_block(model, node, loadTable, cfg, x, y)

% Initialize return values
blk = '';
hasLoad = false;

% Aggregate load at this pole
svc = loadTable(strcmp(loadTable.PoleID, node), :);

if isempty(svc) || height(svc) == 0
    return;
end

blkName = sprintf('Load_%s', strrep(node, '-', '_'));  % Replace dashes for valid block name
blk = blkName;  % Return just the block name, not full path

add_block('powerlib/Elements/Three-Phase Dynamic Load', [model '/' blkName], ...
    'Position',[x y x+80 y+60]);

% Calculate total load
P = sum(svc.kW) * 1e3;  % W
pf = cfg.load.pf;
Q = P * tan(acos(pf));  % var

% Set parameters according to the dialog structure
% NominalVoltage: [Vn(Vrms) fn(Hz)]
% ActiveReactivePowers: [Po(W) Qo(var)]
set_param([model '/' blkName], ...
    'NominalVoltage', sprintf('[%g %g]', cfg.V_ln_nom, cfg.f_nom), ...
    'ActiveReactivePowers', sprintf('[%g %g]', P, Q));

hasLoad = true;

end