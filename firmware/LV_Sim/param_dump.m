blk = 'untitled/AC Cable (Three-Phase)';
m = Simulink.Mask.get(blk);

for i = 1:length(m.Parameters)
    p = m.Parameters(i);
    fprintf('\nPrompt      : %s', p.Prompt);
    fprintf('\nMaskVar     : %s', p.Name);
    fprintf('\nValue       : %s', get_param(blk, p.Name));
    fprintf('\nType        : %s\n', p.Type);
end
