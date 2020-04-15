stock IsVehicleOccupied(vehicleid) // Returns 1 if there is anyone in the vehicle
{
    for(new i=0; i<GetMaxPlayers(); i++)
    {
        if(IsPlayerInAnyVehicle(i))
        {
            if(GetPlayerVehicleID(i)==vehicleid)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }
	}
	return 0;
}
