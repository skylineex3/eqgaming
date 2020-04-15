stock GetObjectUID(objectid)
{
 	new uid = 0;
	for(new i=1; i<MAX_OBJECTS; i++)
	{
	    if(Object[i][object_sampid] == objectid)
	    {
	        uid = Object[i][object_uid];
	        break;
		}
	}
	return uid;
}
