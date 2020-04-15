public OnPlayerSelectDynamicObject(playerid, objectid, modelid, Float:x, Float:y, Float:z)
{
	PlayerData[playerid][char_edit_object] = objectid;
	CancelSelectTextDraw(playerid);
	return 0;
}
