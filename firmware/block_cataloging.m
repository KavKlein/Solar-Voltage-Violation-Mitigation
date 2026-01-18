clc;
load_system('simscape');
load_system('ee_lib');      % Specialized Power Systems (SPS)

blocks1 = find_system('simscape', ...
    'Type', 'Block');
fid1 = fopen('simscape_block_catalog.txt','w');
fprintf(fid1, '%s\n', blocks1{:});
fclose(fid1);

disp('Simscape block catalog exported to simscape_block_catalog.txt');

disp(blocks1)

blocks2 = find_system('ee_lib', ...
    'Type', 'Block');

fid2 = fopen('eelib_block_catalog.txt','w');
fprintf(fid2, '%s\n', blocks2{:});
fclose(fid2);

disp('eelib block catalog exported to eelib_block_catalog.txt');
disp(blocks2)

find_system('ee_lib', 'Name', '*Bus*')
find_system('ee_lib', 'Name', '*Load*')
find_system('ee_lib', 'Name', '*Line*')
find_system('ee_lib', 'Name', '*Transformer*')
find_system('ee_lib', 'Name', '*Measurement*')

find_system('ee_lib', 'Name', '*Inverter*')
find_system('ee_lib', 'Name', '*PV*')
find_system('ee_lib', 'Name', '*Renewable*')



