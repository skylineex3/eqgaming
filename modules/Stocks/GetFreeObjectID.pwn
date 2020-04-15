stock GetFreeObjectID()
{
	new object = -1;
	for(new i=1; i<MAX_OBJECTS; i++)
	{
	    if(Object[i][object_uid] == 0)
	    {
	        object = i;
	        break;
		}
	}
	return object;
}
