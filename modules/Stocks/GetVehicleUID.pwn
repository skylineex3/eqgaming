stock GetVehicleUID(vehicleid)
{
	new uid = 0;
	for(new i=0; i<MAX_VEHICLES; i++)
	{
	    if(Vehicle[i][samp_id] == vehicleid)
	    {
			uid = Vehicle[i][veh_uid];
			break;
		}
	}
	return uid;
}
