function add_feeder(model, fd, cfg, cond, loadTable, solarTable, x0, y0)

fprintf('Processing feeder with %d segments\n', height(fd));

% Start from transformer secondary
prev = 'Transformer';
prevPort = 'LConn2';  % Left connection port 2 (LV side)

x = x0;
y = y0;

for k = 1:height(fd)
    
    % Access table row properly with correct column names
    fromPole = fd.FromPole{k};
    toPole = fd.ToPole{k};
    len_m = fd.Span_m(k);  % Correct column name from Excel
    conductor = fd.Conductor{k};
    feederName = fd.Feeder{k};

    % Create unique names for this segment (after sanitization)
    lineName = sprintf('%s_Line_%s_%s', feederName, fromPole, toPole);
    nodeName = sprintf('%s_Node_%s', feederName, toPole);
    
    % Additional sanitization for line and node names
    lineName = strrep(lineName, '/', '_');
    lineName = strrep(lineName, '\', '_');
    lineName = strrep(lineName, ' ', '_');
    
    nodeName = strrep(nodeName, '/', '_');
    nodeName = strrep(nodeName, '\', '_');
    nodeName = strrep(nodeName, ' ', '_');

    %% PI LINE
    blkLine = [model '/' lineName];
    add_block('powerlib/Elements/Three-Phase PI Section Line', blkLine,...
        'Position',[x y x+100 y+80]);

    condType = conductor;
    condType = strrep(condType, ' ', '');   % Remove spaces
    condType = strrep(condType, '-', '');   % Remove dashes
    condType = strrep(condType, '_', '');   % Remove underscores
    
    % If format is "70ABC" or "50ABC", convert to "ABC70", "ABC50"
    if contains(condType, 'ABC')
        % Extract the number
        numPart = regexp(condType, '\d+', 'match');
        if ~isempty(numPart)
            condType = ['ABC' numPart{1}];
        else
            % No number found, default to ABC70
            condType = 'ABC70';
        end
    else
        % Doesn't contain ABC at all
        condType = 'ABC70';
    end
    
    % Check if conductor type exists in library
    if ~isfield(cond, condType)
        warning('Conductor type %s not found, using ABC70 as default', condType);
        condType = 'ABC70';
    end
    
    % Set parameters with correct names
    set_param(blkLine,...
        'Frequency', '50',...
        'Length', num2str(len_m/1000),...
        'Resistances', mat2str(cond.(condType).r),...
        'Inductances', mat2str(cond.(condType).l),...
        'Capacitances', mat2str(cond.(condType).c));

    %% CONNECT LINE TO PREVIOUS NODE
    if k == 1
        % First segment connects to transformer
        add_line(model, [prev '/' prevPort], [lineName '/LConn1'], 'autorouting','on');
    else
        % Subsequent segments connect to previous line output
        add_line(model, [prev '/RConn2'], [lineName '/LConn1'], 'autorouting','on');
    end

    %% ADD LOADS
    [loadBlk, hasLoad] = add_load_block(model, toPole, loadTable, cfg, x+150, y);
    if hasLoad
        fprintf('    Added load: %s\n', loadBlk);
    end
    
    %% ADD PV
    [pvBlk, hasPV] = add_pv_block(model, toPole, solarTable, cfg, x+150, y+100);
    if hasPV
        fprintf('    Added PV: %s\n', pvBlk);
    end

    %% ADD VOLTAGE MEASUREMENT
    
    % vmBlk = add_voltage_measurement(model, nodeName, x+150, y-80);
    % fprintf('    Added VM: %s\n', vmBlk);

    %% CONNECT LOADS/PV/VM TO LINE 
    % Use block names without model prefix
    lineBlkShort = strrep(lineName, [model '/'], '');
    
    if hasLoad
        add_line(model, [lineBlkShort '/RConn2'], [loadBlk '/LConn1'], 'autorouting','on');
    end
    
    if hasPV
        add_line(model, [lineBlkShort '/RConn2'], [pvBlk '/LConn1'], 'autorouting','on');
    end

    % Update previous node for next iteration
    prev = lineName;
    x = x + 350;
end

end