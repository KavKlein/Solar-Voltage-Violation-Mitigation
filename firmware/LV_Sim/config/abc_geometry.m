function g = abc_geometry(type)

switch upper(type)
    case 'ABC70'
        g.gmr      = 5e-3;
        g.srad     = 10e-3;
        g.cablerad = 20e-3;
        g.Dab      = 25e-3;
        g.epsr     = 2.4;
        g.rho      = 100;
        g.Rg       = 0.2;
    case 'ABC50'
        g.gmr      = 4.5e-3;
        g.srad     = 9e-3;
        g.cablerad = 18e-3;
        g.Dab      = 22e-3;
        g.epsr     = 2.4;
        g.rho      = 100;
        g.Rg       = 0.25;
    otherwise
        error('Unknown ABC type: %s', type);
end
end
