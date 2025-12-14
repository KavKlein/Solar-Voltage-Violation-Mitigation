function pf = recommend_pf(results)

if isempty(results)
    pf = 1.0;
    return
end

% Conservative utility-grade recommendation
pf = 0.95;

end
