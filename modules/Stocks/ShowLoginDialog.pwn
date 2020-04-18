stock ShowLoginDialog(playerid, type)
{
	if(type == 1)
	{
	    new String[256];
		format(String, sizeof(String), "Witamy na eQualityGaming.pl Roleplay\n\nLogujesz siê na postaæ %s. Poni¿ej wpisz has³o i naciœnij 'Zaloguj'.\n\n(*) Now¹ postaæ mo¿esz za³o¿yæ na naszym forum b¹dŸ klikaj¹c 'Zmieñ' a potem 'Stwórz'.\n(*) Mo¿esz zmieniæ postaæ klikaj¹c 'Zmieñ'.", PlayerName(playerid));

		ShowPlayerDialog(playerid, D_LOGIN, DIALOG_STYLE_PASSWORD, "Logowanie", String, "Zaloguj", "Zmieñ");
	}
	else if(type == 2)
	{
	    new String[256];
		format(String, sizeof(String), "Witamy na eQualityGaming.pl Roleplay\n\nNie odnaleziono postaci %s. Poni¿ej wpisz Imie_Nazwisko i naciœnij 'Zmieñ'.\n\n(*) Now¹ postaæ mo¿esz za³o¿yæ na naszym forum b¹dŸ klikaj¹c 'Stwórz'.", PlayerName(playerid));

	    ShowPlayerDialog(playerid, D_LOGIN_CN, DIALOG_STYLE_INPUT, "Logowanie » Brak postaci", String, "Zmieñ", "Stwórz");
	}
	else if(type == 3)
	{
		ShowPlayerDialog(playerid, D_LOGIN_CN, DIALOG_STYLE_INPUT, "Logowanie » Wybór postaci", "Witamy na eQualityGaming.pl Roleplay\n\nPoni¿ej wpisz Imie i Nazwisko postaci lub za³ó¿ postaæ na naszym forum.\n(*) Mo¿esz te¿ stworzyæ postaæ w grze klikaj¹c w przycisk 'Stwórz'.", "Zmieñ", "Stwórz");
	}
	else if(type == 4)
	{
	    new String[256];
		format(String, sizeof(String), "Witamy na eQualityGaming.pl Roleplay\n\nPostaæ %s na któr¹ próbujesz siê zalogowaæ jest zablokowana b¹dŸ uœmiercona.\nPoni¿ej wpisz Imie_Nazwisko i naciœnij 'Zmieñ'.\n\n(*) Now¹ postaæ mo¿esz za³o¿yæ na naszym forum b¹dŸ klikaj¹c 'Stwórz'.", PlayerName(playerid));

	    ShowPlayerDialog(playerid, D_LOGIN_CN, DIALOG_STYLE_INPUT, "Logowanie » B³¹d", String, "Zmieñ", "Stwórz");
	}
	return true;
}

