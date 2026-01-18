% Check Simscape Electrical library structure
sscLib = 'fl_lib';  % Foundation Library in newer MATLAB
if exist(sscLib, 'file') == 4
    find_system(sscLib, 'SearchDepth', 2)
else
    disp('Foundation Library not found, checking powerlib...');
    find_system('powerlib', 'SearchDepth', 1)
end