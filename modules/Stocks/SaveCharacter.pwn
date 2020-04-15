stock SaveCharacter(playerid)
{
	new DB_Query[1000];
	format(DB_Query, sizeof(DB_Query), "UPDATE `rp_chars` SET char_admin_level = %d, char_health = %f, char_last_pos_x = %f, char_last_pos_y = %f, char_last_pos_z = %f, char_last_pos_a = %f, char_interior = %d, char_virtual_world = %d, char_cash = %d, char_bank = %d, char_skin = %d, char_strength = %d, char_sex = %d, char_bw = %d, char_premium = %d, char_online = %d, char_score = %d, char_last_damaged_weapon = %d WHERE `char_name` = '%s' LIMIT 1",
		PlayerData[playerid][char_admin_level], PlayerData[playerid][char_health], PlayerData[playerid][char_last_pos][0], PlayerData[playerid][char_last_pos][1], PlayerData[playerid][char_last_pos][2], PlayerData[playerid][char_last_pos][3],
			PlayerData[playerid][char_interior], PlayerData[playerid][char_virtual_world], PlayerData[playerid][char_cash], PlayerData[playerid][char_bank], PlayerData[playerid][char_skin], PlayerData[playerid][char_strength], PlayerData[playerid][char_sex], PlayerData[playerid][char_bw], PlayerData[playerid][char_premium], PlayerData[playerid][char_online], PlayerData[playerid][char_score], PlayerData[playerid][char_last_damaged_weapon], PlayerData[playerid][char_name]);
	mysql_query(DB_Query);

	format(DB_Query, sizeof(DB_Query), "UPDATE `rp_chars` SET char_bodypart_damaged_torso = %d, char_bodypart_damaged_groin = %d, char_bodypart_damaged_leftarm = %d, char_bodypart_damaged_rightarm = %d, char_bodypart_damaged_leftleg = %d, char_bodypart_damaged_rightleg = %d, char_bodypart_damaged_head = %d, char_debt = %d, char_bank_number = %d WHERE `char_name` = '%s' LIMIT 1",
		PlayerData[playerid][char_body_part_damaged][0], PlayerData[playerid][char_body_part_damaged][1], PlayerData[playerid][char_body_part_damaged][2], PlayerData[playerid][char_body_part_damaged][3], PlayerData[playerid][char_body_part_damaged][4], PlayerData[playerid][char_body_part_damaged][5], PlayerData[playerid][char_body_part_damaged][6], PlayerData[playerid][char_debt], PlayerData[playerid][char_bank_number] - PlayerData[playerid][char_uid], PlayerData[playerid][char_name]);
	mysql_query(DB_Query);

	format(DB_Query, sizeof(DB_Query), "UPDATE `rp_chars` SET char_weight = %d, char_height = %d, char_age = %d, char_ingame = 0, char_lastonline = %d WHERE `char_name` = '%s' LIMIT 1",
	    PlayerData[playerid][char_weight], PlayerData[playerid][char_height], PlayerData[playerid][char_age], gettime(), PlayerData[playerid][char_name]);
	mysql_query(DB_Query);
	return 1;
}
