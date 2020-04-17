stock ShowLoginDialog(playerid, type)
{
	if(type == 1)
	{
	    new String[256];
		format(String, sizeof(String), "Witamy na eQualityGaming.pl Roleplay\n\nLogujesz się na postać %s. Poniżej wpisz hasło i naciśnij 'Zaloguj'.\n\n(*) Nową postać możesz założyć na naszym forum bądź klikając 'Zmień' a potem 'Stwórz'.\n(*) Możesz zmienić postać klikając 'Zmień'.", PlayerName(playerid));

		ShowPlayerDialog(playerid, D_LOGIN, DIALOG_STYLE_PASSWORD, "Logowanie", String, "Zaloguj", "Zmień");
	}
	else if(type == 2)
	{
	    new String[256];
		format(String, sizeof(String), "Witamy na eQualityGaming.pl Roleplay\n\nNie odnaleziono postaci %s. Poniżej wpisz Imie_Nazwisko i naciśnij 'Zmień'.\n\n(*) Nową postać możesz założyć na naszym forum bądź klikając 'Stwórz'.", PlayerName(playerid));

	    ShowPlayerDialog(playerid, D_LOGIN_CN, DIALOG_STYLE_INPUT, "Logowanie » Brak postaci", String, "Zmień", "Stwórz");
	}
	else if(type == 3)
	{
		ShowPlayerDialog(playerid, D_LOGIN_CN, DIALOG_STYLE_INPUT, "Logowanie » Wybór postaci", "Witamy na eQualityGaming.pl Roleplay\n\nPoniżej wpisz Imie i Nazwisko postaci lub załóż postać na naszym forum.\n(*) Możesz też stworzyć postać w grze klikając w przycisk 'Stwórz'.", "Zmień", "Stwórz");
	}
	else if(type == 4)
	{
	    new String[256];
		format(String, sizeof(String), "Witamy na eQualityGaming.pl Roleplay\n\nPostać %s na którą próbujesz się zalogować jest zablokowana bądź uśmiercona.\nPoniżej wpisz Imie_Nazwisko i naciśnij 'Zmień'.\n\n(*) Nową postać możesz założyć na naszym forum bądź klikając 'Stwórz'.", PlayerName(playerid));

	    ShowPlayerDialog(playerid, D_LOGIN_CN, DIALOG_STYLE_INPUT, "Logowanie » Błąd", String, "Zmień", "Stwórz");
	}
	return true;
}
