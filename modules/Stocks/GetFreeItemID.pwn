stock GetFreeItemID()
{
	new item = -1;
	for(new i=1; i<MAX_ITEMS; i++)
	{
	    if(Item[i][UID] == -1)
	    {
			item = i;
			break;
		}
	}
	return item;
}
