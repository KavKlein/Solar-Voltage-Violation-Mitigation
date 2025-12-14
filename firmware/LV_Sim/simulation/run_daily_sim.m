function run_daily_sim(modelName, cfg)

set_param(modelName,'StopTime',num2str(cfg.T_sim),...
          'Solver',cfg.solver);

sim(modelName);

end
