function add_feeder(model, fd, cfg, cond, x0, y0)

prev = [model '/LV_BUS'];

x = x0;
y = y0;

for k = 1:length(fd.segments)

    seg = fd.segments(k);

    node = sprintf('%s_%s', fd.name, seg.to);
    line = sprintf('%s_L%d', fd.name, k);

    %% --- PI LINE ---
    blkLine = [model '/' line];
    add_block('powerlib/Elements/Three-Phase PI Section Line', blkLine,...
        'Position',[x y x+80 y+60]);

    set_param(blkLine,...
        'Length', num2str(seg.len_m/1000),...
        'Resistance', mat2str(cond.(seg.cond).R),...
        'Inductance', mat2str(cond.(seg.cond).L),...
        'Capacitance', mat2str(cond.(seg.cond).C));

    %% --- NODE BUS ---
    blkBus = [model '/' node];
    add_block('powerlib/Elements/Three-Phase Busbar', blkBus,...
        'Position',[x+120 y x+150 y+60]);

    %% --- CONNECT LINE ---
    add_line(model,[get_param(prev,'Name') '/1'],[line '/1'],'autorouting','on');
    add_line(model,[line '/2'],[node '/1'],'autorouting','on');

    %% --- LOAD ---
    if seg.nsvc > 0
        add_load_block(model, node, seg, cfg, x+200, y);
    end

    %% --- SOLAR PV ---
    if isfield(seg,'has_pv') && seg.has_pv
        add_pv_block(model, node, seg, cfg, x+200, y+80);
    end

    %% --- VOLTAGE MEASUREMENT ---
    add_voltage_measurement(model, node, x+200, y-60);

    prev = blkBus;
    x = x + 300;
end
end
