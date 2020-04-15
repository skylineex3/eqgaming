stock GetFreeVehicleID()
{
	new uid = -1;
	for(new i=1; i<MAX_VEHICLES; i++)
	{
	    if(Vehicle[i][veh_uid] == -1)
	    {
	        uid = i;
	        break;
		}
	}
	return uid;
}
