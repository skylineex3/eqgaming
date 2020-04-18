stock EscapePL(name[])
{
    for(new i = 0; name[i] != 0; i++)
    {
	    if(name[i] == 'ú') name[i] = 's';
	    else if(name[i] == 'Í') name[i] = 'e';
	    else if(name[i] == 'Û') name[i] = 'o';
	    else if(name[i] == 'π') name[i] = 'a';
	    else if(name[i] == '≥') name[i] = 'l';
	    else if(name[i] == 'ø') name[i] = 'z';
	    else if(name[i] == 'ü') name[i] = 'z';
	    else if(name[i] == 'Ê') name[i] = 'c';
	    else if(name[i] == 'Ò') name[i] = 'n';
	    else if(name[i] == 'å') name[i] = 'S';
	    else if(name[i] == ' ') name[i] = 'E';
	    else if(name[i] == '”') name[i] = 'O';
	    else if(name[i] == '•') name[i] = 'A';
	    else if(name[i] == '£') name[i] = 'L';
	    else if(name[i] == 'Ø') name[i] = 'Z';
	    else if(name[i] == 'è') name[i] = 'Z';
	    else if(name[i] == '∆') name[i] = 'C';
	    else if(name[i] == '—') name[i] = 'N';
	    //else if(name[i] == ' ') name[i] = '_';
    }
}

