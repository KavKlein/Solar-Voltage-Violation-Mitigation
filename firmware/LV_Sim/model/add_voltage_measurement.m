function blk = add_voltage_measurement(model, node, x, y)

vmName = sprintf('VM_%s', strrep(node, '-', '_'));
blk = vmName; 

% Check if block already exists (node might be shared between feeders)
if ~isempty(find_system(model, 'SearchDepth', 1, 'Name', vmName))
    fprintf('    VM block %s already exists, skipping\n', vmName);
    return;
end

add_block('powerlib/Measurements/Three-Phase V-I Measurement', [model '/' vmName], ...
    'Position',[x y x+60 y+80]);

% Configure to measure voltage to ground (not between terminals)
% ******This requires the block to have its negative terminal grounded****
set_param([model '/' vmName], ...
    'VoltageMeasurement', 'phase-to-ground', ...
    'OutputType', 'Magnitude');

end