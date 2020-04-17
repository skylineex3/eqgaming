forward EngineStart(playerid);
public EngineStart(playerid)
{
	new vehid = GetPlayerVehicleID(playerid);
	new uid = GetVehicleUID(vehid);

	if(Vehicle[uid][veh_fuel] == 0.0)
		return cmd_me(playerid, "próbuje odpalić silnik w pojeździe ale silnik nie odpala.");

	new engine,lights,alarm,doors,bonnet,boot,objective;
	GetVehicleParamsEx(vehid,engine,lights,alarm,doors,bonnet,boot,objective);
    SetVehicleParamsEx(vehid,1,lights,alarm,doors,bonnet,boot,objective);
	return 1;
}
