enum ENUM_OBJECT_INFO
{
	object_sampid,
	object_uid,
	object_model,
	Float:object_pos[6],
	object_world,
	object_interior,

	object_mmat_uid,

	object_mmat_index[16],
	object_mmat_type,
	object_mmat_color,
	object_mmat_modelid,
	object_mmat_txdname[32],
	object_mmat_texturename[64],

	object_mmat_size,
	object_mmat_fontsize,
	object_mmat_fontcolor,
	object_mmat_backcolor,
	object_mmat_bold,
	object_mmat_align,
	object_mmat_font[32],
	object_mmat_text[64]
}

new Object[MAX_OBJECTS][ENUM_OBJECT_INFO];
