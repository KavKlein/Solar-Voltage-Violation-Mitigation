function net = read_network_data(fname)

T = readtable(fname, 'Sheet', 'NetworkSegments');

% Remove empty rows (where Feeder or FromPole or ToPole is empty/missing)
validRows = ~cellfun(@isempty, T.Feeder) & ...
            ~cellfun(@isempty, T.FromPole) & ...
            ~cellfun(@isempty, T.ToPole);

T = T(validRows, :);

fprintf('Loaded %d valid network segments\n', height(T));

net.segments = T;

% Build pole table
svcCol = T.('ServicesatPole');

svcCol = fillmissing(svcCol,'constant',0);

svcCol = double(svcCol);   % force numeric

poles = unique(T.ToPole);

n = numel(poles);
poleTable = table('Size',[n 2], ...
    'VariableTypes',{'string','double'}, ...
    'VariableNames',{'PoleID','NumServices'});

for i = 1:n
    poleTable.PoleID(i) = poles{i};
    idx = strcmp(T.ToPole, poles{i});
    poleTable.NumServices(i) = sum(svcCol(idx));
end

net.poleTable = poleTable;
net.total_services = sum(poleTable.NumServices);

fprintf('Total poles: %d\n', height(poleTable));
fprintf('Total services: %d\n', net.total_services);

end