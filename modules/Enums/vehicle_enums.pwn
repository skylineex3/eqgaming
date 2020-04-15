enum ENUM_VEHICLE_INFO
{
	veh_uid,
	veh_model,
	Float:veh_health,
	Float:veh_pos[4],
	veh_color[2],
	//na póŸniej
	veh_tires,
	veh_doors,
	veh_panels,
	veh_lights,
	//dalej
	veh_world,
	veh_interior,
	Float:veh_fuel,
	Float:veh_mileage,
	veh_owner,
	veh_paintjob,
	bool:veh_spawned,
	bool:veh_locked,
	samp_id
}

new Vehicle[MAX_VEHICLES][ENUM_VEHICLE_INFO];
