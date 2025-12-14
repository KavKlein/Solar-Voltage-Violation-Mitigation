function add_load(modelName, node, P_kW, PF, phase)

blk = [modelName '/Load_' node];

add_block('powerlib/Elements/Three-Phase Dynamic Load', blk);

Q = P_kW * tan(acos(PF));

set_param(blk,...
 'ActivePower',num2str(P_kW*1e3),...
 'ReactivePower',num2str(Q*1e3));

end
