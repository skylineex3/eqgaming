stock EscapePL(name[])
{
    for(new i = 0; name[i] != 0; i++)
    {
	    if(name[i] == 'ś') name[i] = 's';
	    else if(name[i] == 'ę') name[i] = 'e';
	    else if(name[i] == 'ó') name[i] = 'o';
	    else if(name[i] == 'ą') name[i] = 'a';
	    else if(name[i] == 'ł') name[i] = 'l';
	    else if(name[i] == 'ż') name[i] = 'z';
	    else if(name[i] == 'ź') name[i] = 'z';
	    else if(name[i] == 'ć') name[i] = 'c';
	    else if(name[i] == 'ń') name[i] = 'n';
	    else if(name[i] == 'Ś') name[i] = 'S';
	    else if(name[i] == 'Ę') name[i] = 'E';
	    else if(name[i] == 'Ó') name[i] = 'O';
	    else if(name[i] == 'Ą') name[i] = 'A';
	    else if(name[i] == 'Ł') name[i] = 'L';
	    else if(name[i] == 'Ż') name[i] = 'Z';
	    else if(name[i] == 'Ź') name[i] = 'Z';
	    else if(name[i] == 'Ć') name[i] = 'C';
	    else if(name[i] == 'Ń') name[i] = 'N';
	    //else if(name[i] == ' ') name[i] = '_';
    }
}
