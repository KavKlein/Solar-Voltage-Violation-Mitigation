function add_parallel_resistance(model, nodeName, x, y)
% Adds a high-value parallel resistance to prevent current source conflicts
% This represents leakage/insulation resistance in real systems

resName = sprintf('R_snubber_%s', strrep(nodeName, '-', '_'));

% Check if already exists
if ~isempty(find_system(model, 'SearchDepth', 1, 'Name', resName))
    return;
end

% Add three-phase parallel RLC load (used as pure resistance)
add_block('powerlib/Elements/Three-Phase Parallel RLC Load', ...
    [model '/' resName], ...
    'Position', [x y x+60 y+40]);

% Set very high resistance (1 M?) - minimal current draw
% This prevents numerical issues without affecting results
set_param([model '/' resName], ...
    'NominalVoltage', '230', ...
    'NominalFrequency', '50', ...
    'ActivePower', '0.1', ...  % Very small: 0.1W per phase
    'InductivePower', '0', ...
    'CapacitivePower', '0', ...
    'LoadType', 'constant z');


end