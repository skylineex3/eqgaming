stock UnloadZones()
{
	for(new i=1; i<MAX_ZONES; i++)
	{
	    GangZoneDestroy(Zone[i][z_sampid]);

	    Zone[i][z_uid] = 0;
	    format(Zone[i][z_name], 32, " ");
	    Zone[i][z_min][0] = 0.0;
	    Zone[i][z_min][1] = 0.0;
	    Zone[i][z_max][0] = 0.0;
	    Zone[i][z_max][1] = 0.0;
	    Zone[i][z_owner] = 0;
	    Zone[i][z_house_cost] = 0;
	    Zone[i][z_buis_cost] = 0;
	    Zone[i][z_size] = 0;
	}
	return 1;
}
