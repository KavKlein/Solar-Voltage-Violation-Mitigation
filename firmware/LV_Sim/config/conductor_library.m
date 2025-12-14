function lib = conductor_library()

% Values at ~32°C, Sri Lanka
% r1 r0 [?/km], l1 l0 [H/km], c1 c0 [F/km]

lib.ABC70.r = [0.464 1.39];
lib.ABC70.l = [0.70e-3 2.10e-3];
lib.ABC70.c = [12e-9 8e-9];

lib.ABC50.r = [0.672 2.02];
lib.ABC50.l = [0.72e-3 2.16e-3];
lib.ABC50.c = [11e-9 7e-9];

lib.ABC35.r = [0.868 2.60];
lib.ABC35.l = [0.75e-3 2.25e-3];
lib.ABC35.c = [10e-9 6e-9];

end
