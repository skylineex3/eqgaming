#define DEBUG_MODE                      1 //1 - debug[ON], 2 - debug[OFF]

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define HOLDING(%0) \
	((newkeys & (%0)) == (%0))

#undef MAX_VEHICLES
#define MAX_VEHICLES                    5000

#undef MAX_OBJECTS
#define MAX_OBJECTS                     50000

#define MAX_ZONES                       1000

#define MAX_DOORS                       5000

//#define APIKEY                        "99a54aed0e77ca64bac2d3ddc8c1558909252cf467ed2e0570993617172aef89"


#define SQL_HOST                        "51.83.129.92"
#define SQL_DB                          "forum"
#define SQL_PASS                        "#wl52OrGPKS"
#define SQL_USER                        "root"



#define SQL_HOST2                       "localhost"
#define SQL_USER2                       "root"
#define SQL_PASS2                       ""
#define SQL_DB2                         "test"


#define COLOR_SAY_FADE1     			0xE6E6E6E6
#define COLOR_SAY_FADE2     			0xC8C8C8C8
#define COLOR_SAY_FADE3     			0xAAAAAAAA
#define COLOR_SAY_FADE4     			0x8e8e8d8d
#define COLOR_SAY_FADE5     			0x8e8e8d8d
#define COLOR_FADE1         			"E6E6E6"
#define COLOR_FADE2         			"C8C8C8"
#define COLOR_FADE3         			"AAAAAA"
#define COLOR_FADE4         			"8e8d8d"
#define COLOR_FADE5         			"8e8d8d"
#define COLOR_PURPLE 	  				0xC2A3DAFF
#define COLOR_PURPLE2 					0xb599ccFF
#define COLOR_PURPLE3 					0xa58bbaFF
#define COLOR_PURPLE4 					0x9780aaFF
#define COLOR_PURPLE5 					0x857096FF
#define COLOR_DO 	        			0xA4A3DAFF
#define COLOR_DO2 		    			0x9999ccFF
#define COLOR_DO3 		    			0x8d8dbcFF
#define COLOR_DO4 		    			0x8383afFF
#define COLOR_DO5 		    			0x7a7aa3FF
#define COLOR_GLOB                      0xFF9966FF

#define STAGE_OBJECT_NONE               0
#define STAGE_OBJECT_POS                1
#define STAGE_OBJECT_ROT                2

#define ITEM_NONE               		0
#define ITEM_WEAPON             		1
#define ITEM_MONEY              		2
#define ITEM_DISC               		3
#define ITEM_CLEAN_DISC         		4
#define ITEM_HEALTH             		5
#define ITEM_MP4                        6
#define ITEM_PREMIUM                    7

#define STAGE_ZONE_NONE     			0
#define STAGE_ZONE_SET_X    			1
#define STAGE_ZONE_SET_Y    			2
#define STAGE_ZONE_SAVE     			3

#define D_LOGIN                 		100
#define D_LOGIN_CN              		101
#define D_CREATE_ITEM           		102
#define D_CT_CHANGE_NAME        		103
#define D_CT_CHANGE_TYPE        		104
#define D_CT_CHANGE_VAR_1       		105
#define D_CT_CHANGE_VAR_2       		106
#define D_CT_CHANGE_VAR_3       		107
#define D_CT_CHANGE_VAR_4       		108
#define D_CT_CHANGE_VAR_5       		109
#define D_CT_CHANGE_VAR_6       		110
#define D_CT_CHANGE_OWNER       		111
#define D_ITEMS                 		112
#define D_VEHICLES              		113
#define D_CREATE_VEHICLE                114
#define D_VEHICLE_CN                    115
#define D_VEHICLE_CHP                   116
#define D_VEHICLE_CK1                   117
#define D_VEHICLE_CK2                   118
#define D_VEHICLE_CO                    119
#define D_ITEM_DISC                     120
#define D_ITEM_DISC2                    121
#define D_ID                            122
#define D_ADMINS                        123
#define D_NEAREST_ITEMS                 124
#define D_ITEM_OPTIONS                  125
#define D_STATS                         126
#define D_AREA              			127
#define D_AREA_CHANGE_OWNER 			128
#define D_AREA_CHANGE_HOUSE_COST        129
#define D_AREA_CHANGE_BUISNESS_COST     130
#define D_AREA_CHANGE_SIZE              131
#define D_BANK                          132
#define D_BANK_WPLAC                    133
#define D_BANK_WYPLAC                   134
#define D_BANK_PRZELEW                  135
#define D_BANK_DEBT                     136
#define D_DOORS                         137
#define D_DOORS_2                       138
#define D_VEHICLE_INFO                  139
#define D_VEHICLE_SELL                  140
#define D_VEHICLE_SELL2                 141
#define D_VEHICLE_SELL3                 142
#define D_VEHICLE_GIVE                  143
#define D_VEHICLE_GIVE2                 144
#define D_CREATE_CHAR					145

#define MAX_LINE 						120
#define MAX_ITEMS                       500

#define SEX_MALE                        0
#define SEX_FEMALE                      1

#define KEY_AIM 						(128)

#define Info(%1,%2)             		ShowPlayerDialog(%1, 9999, DIALOG_STYLE_MSGBOX, "Informacja", %2, "Zamknij", "")
