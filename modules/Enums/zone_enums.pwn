enum ENUM_ZONE_INFO
{
	z_uid,
	z_sampid,
	z_name[32],
	Float:z_min[2],
	Float:z_max[2],
	z_owner,
	z_house_cost,
	z_buis_cost,
	z_size
}

new Zone[MAX_ZONES][ENUM_ZONE_INFO];
