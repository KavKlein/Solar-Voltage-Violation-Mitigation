function add_feeder(model, fd, cfg, loadTable, solarTable, x0, y0)

% Debug: show what we're working with
fprintf('Processing feeder with %d segments\n', height(fd));

prev = 'Transformer';
prevPort = 'RConn2'; 

% Start from transformer secondary - no busbar needed
% Feeders branch directly from transformer output
%if k == 1
    % First segment connects directly to transformer
%    prev = 'Transformer';
%    prevPort = 'RConn2';  % Transformer secondary output
%else
%    prev = lineName;  % Will be set from previous iteration
%    prevPort = 'RConn2';
%end

x = x0;
y = y0;

% fd is already a filtered table of segments for this feeder
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

    

    %% --- PI LINE ---
    blkLine = [model '/' lineName];
    add_block('ee_lib/Passive/Lines/AC Cable (Three-Phase)', blkLine,...
        'Position',[x y x+100 y+80]);

    % Extract conductor type properly
    % Excel has: "70ABC", "50ABC", etc.
    % Library expects: "ABC70", "ABC50", etc.
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
    
    
        % Set parameters with correct names
    geoLine = abc_geometry(condType);


set_param(blkLine, ...
    'l', num2str(len_m/1000), ...
    'l_unit','km', ...
    'f', num2str(cfg.f_nom), ...
    'gmr', num2str(geoLine.gmr*1e3), ...
    'gmr_unit','mm', ...
    'srad', num2str(geoLine.srad*1e3), ...
    'srad_unit','mm', ...
    'cablerad', num2str(geoLine.cablerad*1e3), ...
    'cablerad_unit','mm', ...
    'Dab', num2str(geoLine.Dab*1e3), ...
    'Dab_unit','mm', ...
    'epsr', num2str(geoLine.epsr), ...
    'rho', num2str(geoLine.rho), ...
    'Rg', num2str(geoLine.Rg));

    %% --- CONNECT LINE TO PREVIOUS NODE ---
    if k == 1
        % First segment connects to transformer
        add_line(model, [prev '/' prevPort], [lineName '/LConn1'], 'autorouting','on');
    else
        % Subsequent segments connect to previous line output
        add_line(model, [prev '/RConn2'], [lineName '/LConn1'], 'autorouting','on');
    end

    %% --- ADD LOADS ---
    [loadBlk, hasLoad] = add_load_block(model, toPole, loadTable, cfg, x+150, y);
    if hasLoad
        fprintf('    Added load: %s\n', loadBlk);
    end
    
    %% --- ADD PV ---
    [pvBlk, hasPV] = add_pv_block(model, toPole, solarTable, cfg, x+150, y+100);
    if hasPV
        fprintf('    Added PV: %s\n', pvBlk);
    end

    %% --- ADD VOLTAGE MEASUREMENT ---
    % Skip voltage measurements for now - they're causing grounding issues
    % We can add them back later with proper grounding strategy
    % vmBlk = add_voltage_measurement(model, nodeName, x+150, y-80);
    % fprintf('    Added VM: %s\n', vmBlk);

    %% --- CONNECT LOADS/PV/VM TO LINE ---
    % All connect to the right side of the PI line (RConn2)
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