function build_model(modelName, net, cfg, loadTable, solarTable)

% Get conductor library
cond = conductor_library();

% Powergui (required for power system simulation)
blkPowerGui = [modelName '/powergui'];
add_block('powerlib/powergui', blkPowerGui, ...
    'Position',[30 30 120 80]);

% Configure powergui for continuous simulation (avoids current source conflicts)
set_param(blkPowerGui, ...
    'SimulationMode', 'Continuous', ...
    'SampleTime', '0');

% Transformer
add_transformer(modelName, cfg);

% Add a ground at transformer secondary
blkGnd = [modelName '/Ground'];
add_block('powerlib/Elements/Ground', blkGnd, ...
    'Position',[350 280 370 300]);

% Connect ground to transformer neutral
add_line(modelName, 'Transformer/RConn2', 'Ground/LConn1', 'autorouting', 'on');

% Feeders
feeders = unique(net.segments.Feeder);

x0 = 400;
y0 = 150;

for f = 1:numel(feeders)
    % Filter segments by feeder name
    fd = net.segments(strcmp(net.segments.Feeder, feeders{f}), :);

    % Pass the filtered table directly
    add_feeder( ...
        modelName, ...
        fd, ...
        cfg, ...
        cond, ...
        loadTable, ...
        solarTable, ...
        x0, ...
        y0 + 400*(f-1));
end

end