enum CHAR_ENUM_INFO
{
	bool:char_logged,
	char_guid,
	char_uid,
	char_name[24],
	char_edit_object,
	bool:char_editing,
	char_edit_stage,
	char_admin_level,
	Float:char_last_pos[4],
	char_spectate_id,
	char_interior,
	char_virtual_world,
	Float:char_health,
	char_cash,
	char_bank,
	char_skin,
	char_strength,
	char_bw,
	char_sex,
	char_last_pm,
	char_premium,
	char_vehicle_info_timer,
	char_info_timer,
	char_block_ooc,
	char_online,
	char_score,
	char_last_damaged_weapon,
	char_body_part_damaged[7], //0 - Torso, 1 - Groin, 2 - Left arm, 3 - Right arm, 4 - Left leg, 5 - Right leg, 6 - Head
	char_stage,
	char_debt,
	char_bank_number,
	char_inside_doors,
	char_offer_id,
	char_offer_value,
	char_height,
	char_weight,
	char_age,
	char_lastonline,
	char_ingame,

	Text3D:char_desc_text,
	Text3D:char_name_tag,

	Text:char_info
}

new PlayerData[MAX_PLAYERS][CHAR_ENUM_INFO];
