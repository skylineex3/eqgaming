stock ShowLoginDialog(playerid, type)
{
	if(type == 1)
	{
	    new String[256];
		format(String, sizeof(String), "Witamy na forgame.pl Roleplay\n\nLogujesz siê na postaæ %s. Poni¿ej wpisz has³o i naciœnij 'Zaloguj'.\n\n(*) Now¹ postaæ mo¿esz za³o¿yæ na naszym forum.\n(*) Mo¿esz zmieniæ postaæ klikaj¹c 'Zmieñ'.", PlayerName(playerid));

		ShowPlayerDialog(playerid, D_LOGIN, DIALOG_STYLE_PASSWORD, "Logowanie", String, "Zaloguj", "Zmieñ");
	}
	else if(type == 2)
	{
	    new String[256];
		format(String, sizeof(String), "Witamy na forgame.pl Roleplay\n\nNie odnaleziono postaci %s. Poni¿ej wpisz Imie_Nazwisko i naciœnij 'Zmieñ'.\n\n(*) Now¹ postaæ mo¿esz za³o¿yæ na naszym forum.", PlayerName(playerid));

	    ShowPlayerDialog(playerid, D_LOGIN_CN, DIALOG_STYLE_INPUT, "Logowanie » Brak postaci", String, "Zmieñ", "WyjdŸ");
	}
	else if(type == 3)
	{
		ShowPlayerDialog(playerid, D_LOGIN_CN, DIALOG_STYLE_INPUT, "Logowanie » Wybór postaci", "Wpisz poni¿ej 'Imie Nazwisko' postaci.", "Zmieñ", "WyjdŸ");
	}
	else if(type == 4)
	{
	    new String[256];
		format(String, sizeof(String), "Witamy na forgame.pl Roleplay\n\nPostaæ %s na któr¹ próbujesz siê zalogowaæ jest zablokowana b¹dŸ uœmiercona.\nPoni¿ej wpisz Imie_Nazwisko i naciœnij 'Zmieñ'.\n\n(*) Now¹ postaæ mo¿esz za³o¿yæ na naszym forum.", PlayerName(playerid));

	    ShowPlayerDialog(playerid, D_LOGIN_CN, DIALOG_STYLE_INPUT, "Logowanie » B³¹d", String, "Zmieñ", "WyjdŸ");
	}
	return true;
}
