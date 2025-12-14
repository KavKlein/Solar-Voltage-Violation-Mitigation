function [t, mult] = load_profiles()

t = (0:60:86400)';
h = t/3600;

mult = zeros(size(h));

mult(h<6) = 0.35;
mult(h>=6 & h<9) = 0.7;
mult(h>=9 & h<12) = 0.5;
mult(h>=12 & h<14) = 0.7;
mult(h>=14 & h<17) = 0.55;
mult(h>=17 & h<22) = 0.95;
mult(h>=22) = 0.55;

end
