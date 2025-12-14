function build_model(modelName, cfg, cond)

add_block('powerlib/powergui',[modelName '/powergui'],'Position',[30 30 120 80]);

add_transformer(modelName, cfg);

data = readtable('data/LV_Network_Data.xlsx');

feeders = unique(data.Feeder);

x0 = 300; y0 = 200;

for f = 1:length(feeders)
    fd = data(strcmp(data.Feeder,feeders{f}),:);
    add_feeder(modelName, fd, cfg, cond, x0, y0+300*(f-1));
end

end
