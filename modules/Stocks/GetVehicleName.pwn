stock GetVehicleName(vehicleid)
{
	new String[32];
    format(String,sizeof(String),"%s",VehicleNames[GetVehicleModel(vehicleid) - 400]);
    return String;
}
