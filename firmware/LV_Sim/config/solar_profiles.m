function [t, mult] = solar_profiles()

t = (0:60:86400)';
h = t/3600;

mult = zeros(size(h));

mult(h>=6 & h<7)  = 0.15;
mult(h>=7 & h<9)  = 0.5;
mult(h>=9 & h<12) = 0.9;
mult(h>=12 & h<15)= 1.0;
mult(h>=15 & h<17)= 0.7;
mult(h>=17 & h<18)= 0.25;

end
