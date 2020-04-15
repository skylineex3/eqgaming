enum ENUM_ITEM_INFO
{
	Name[64],
	Owner,
	Type,
	UID,
	Var[6],
	Desc[256],
	bool:Active,
	Float:item_pos[3],
	in_vehicle
}

new Item[MAX_ITEMS][ENUM_ITEM_INFO];
