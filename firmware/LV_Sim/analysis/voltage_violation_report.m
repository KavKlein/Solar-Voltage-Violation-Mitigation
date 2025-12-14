function res = voltage_violation_report(modelName, cfg)

vars = evalin('base','who');

Vnodes = vars(contains(vars,'Voltage_'));

res = [];

for i=1:length(Vnodes)
    V = evalin('base',Vnodes{i});
    Vpu = V/cfg.V_ln_nom;
    idx = find(Vpu<cfg.voltage_limits(1) | Vpu>cfg.voltage_limits(2));
    if ~isempty(idx)
        res(end+1).node = Vnodes{i};
        res(end).time = idx;
        res(end).V = V(idx);
    end
end

end
