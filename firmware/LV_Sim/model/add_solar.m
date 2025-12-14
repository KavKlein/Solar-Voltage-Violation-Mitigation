function add_solar(modelName, node, P_kW, PF)

blk = [modelName '/PV_' node];

add_block('powerlib/Elements/Three-Phase Source', blk);

Q = P_kW * tan(acos(PF));

set_param(blk,...
 'PhaseAngle','0',...
 'Amplitude',num2str(P_kW*1e3),...
 'ReactivePower',num2str(Q*1e3));

end
