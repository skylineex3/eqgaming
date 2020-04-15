public OnPlayerConnect(playerid)
{
	for(new i=0; i<255; i++)
	    SendClientMessage(playerid, -1, " ");

    new hour, minute, second;
	gettime(hour, minute, second);
	SetPlayerTime(playerid, hour, minute);

	TryLogin(playerid);

	TextDrawShowForPlayer(playerid, LSNews[0]);
	TextDrawShowForPlayer(playerid, LSNews[1]);
	TextDrawShowForPlayer(playerid, ForGame);

	RemoveBuildingForPlayer(playerid, 6067, 1296.8281, -1427.5078, 19.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 6068, 1247.9141, -1429.9688, 15.1250, 0.25);
	RemoveBuildingForPlayer(playerid, 792, 1256.9844, -1443.0313, 12.7188, 0.25);
	RemoveBuildingForPlayer(playerid, 6052, 1247.9141, -1429.9688, 15.1250, 0.25);
	RemoveBuildingForPlayer(playerid, 6053, 1296.8281, -1427.5078, 19.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 1312, 1343.8594, -1426.0156, 16.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 615, 1328.0859, -1419.7578, 12.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 1329.9219, -1418.5156, 13.8906, 0.25);
	RemoveBuildingForPlayer(playerid, 792, 1256.9844, -1417.7031, 12.7188, 0.25);
	RemoveBuildingForPlayer(playerid, 1307, 1289.7266, -1415.0781, 12.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 1307, 1332.0781, -1415.0781, 12.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 1312, 1307.6172, -1394.4766, 16.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1249.9844, -1481.4609, 9.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1258.1797, -1478.0000, 9.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1250.6563, -1466.0000, 9.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1260.1797, -1454.1016, 9.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 5931, 1114.3125, -1348.1016, 17.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 1440, 1085.7031, -1361.0234, 13.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 1438, 1015.5313, -1337.1719, 12.5547, 0.25);
	RemoveBuildingForPlayer(playerid, 1297, 1112.6172, -1389.8672, 15.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 5810, 1114.3125, -1348.1016, 17.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 5993, 1110.8984, -1328.8125, 13.8516, 0.25);
	RemoveBuildingForPlayer(playerid, 5811, 1131.1953, -1380.4219, 17.0703, 0.25);
	RemoveBuildingForPlayer(playerid, 1440, 1141.9844, -1346.1094, 13.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 5929, 1230.8906, -1337.9844, 12.5391, 0.25);
	RemoveBuildingForPlayer(playerid, 739, 1231.1406, -1341.8516, 12.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 739, 1231.1406, -1328.0938, 12.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 739, 1231.1406, -1356.2109, 12.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1068.1172, -1275.0938, 15.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1184.7891, -1406.9063, 15.3906, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1140.8984, -1280.1172, 15.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1161.5859, -1281.3594, 15.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1182.6484, -1280.0781, 15.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1150.5078, -1269.9375, 15.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1190.3047, -1389.8047, 15.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1194.3203, -1415.2891, 15.3906, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1216.5625, -1394.7109, 15.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1222.6641, -1374.6094, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1222.6641, -1356.5547, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1244.0391, -1406.5313, 15.1641, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1240.9219, -1374.6094, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1240.9219, -1356.5547, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1194.7969, -1290.8516, 15.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1216.3203, -1281.4141, 15.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1216.8516, -1270.7656, 15.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1222.6641, -1335.0547, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1222.6641, -1317.7422, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 5812, 1230.8906, -1337.9844, 12.5391, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1240.9219, -1335.0547, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1240.9219, -1317.7422, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1222.6641, -1300.9219, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1240.9219, -1300.9219, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1245.7266, -1281.3359, 15.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1250.4531, -1389.7500, 15.3984, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1270.8516, -1394.6797, 15.3906, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1261.3594, -1291.1797, 15.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1269.5469, -1280.3203, 15.7109, 0.25);

	SetPlayerColor(playerid, 0x000000FF);

	if(PlayerData[playerid][char_admin_level] > 6)
	{
		UpdateNick(playerid);
    	//Attach3DTextLabelToPlayer(PlayerData[playerid][char_name_tag], playerid, 0.0, 0.0, 0.15);
	}
	else
	{
	    UpdateNick(playerid);
    	//Attach3DTextLabelToPlayer(PlayerData[playerid][char_name_tag], playerid, 0.0, 0.0, 0.15);
	}

	RemoveVendingMachines(playerid);
	return 1;
}
