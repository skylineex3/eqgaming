stock ShowLoginDialog(playerid, type)
{
	if(type == 1)
	{
	    new String[256];
		format(String, sizeof(String), "Witamy na forgame.pl Roleplay\n\nLogujesz si� na posta� %s. Poni�ej wpisz has�o i naci�nij 'Zaloguj'.\n\n(*) Now� posta� mo�esz za�o�y� na naszym forum.\n(*) Mo�esz zmieni� posta� klikaj�c 'Zmie�'.", PlayerName(playerid));

		ShowPlayerDialog(playerid, D_LOGIN, DIALOG_STYLE_PASSWORD, "Logowanie", String, "Zaloguj", "Zmie�");
	}
	else if(type == 2)
	{
	    new String[256];
		format(String, sizeof(String), "Witamy na forgame.pl Roleplay\n\nNie odnaleziono postaci %s. Poni�ej wpisz Imie_Nazwisko i naci�nij 'Zmie�'.\n\n(*) Now� posta� mo�esz za�o�y� na naszym forum.", PlayerName(playerid));

	    ShowPlayerDialog(playerid, D_LOGIN_CN, DIALOG_STYLE_INPUT, "Logowanie � Brak postaci", String, "Zmie�", "Wyjd�");
	}
	else if(type == 3)
	{
		ShowPlayerDialog(playerid, D_LOGIN_CN, DIALOG_STYLE_INPUT, "Logowanie � Wyb�r postaci", "Wpisz poni�ej 'Imie Nazwisko' postaci.", "Zmie�", "Wyjd�");
	}
	else if(type == 4)
	{
	    new String[256];
		format(String, sizeof(String), "Witamy na forgame.pl Roleplay\n\nPosta� %s na kt�r� pr�bujesz si� zalogowa� jest zablokowana b�d� u�miercona.\nPoni�ej wpisz Imie_Nazwisko i naci�nij 'Zmie�'.\n\n(*) Now� posta� mo�esz za�o�y� na naszym forum.", PlayerName(playerid));

	    ShowPlayerDialog(playerid, D_LOGIN_CN, DIALOG_STYLE_INPUT, "Logowanie � B��d", String, "Zmie�", "Wyjd�");
	}
	return true;
}
