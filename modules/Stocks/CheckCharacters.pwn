stock CheckCharacters(givenString[])
{
    new tak = 1;
 	for(new i = 0; givenString[i] != 0; i++)
	{
	    givenString[i] = tolower(givenString[i]);
	    if(givenString[i] != 'q' && givenString[i] != 'w' && givenString[i] != 'e' && givenString[i] != 'r' && givenString[i] != 't' && givenString[i] != 'y' && givenString[i] != 'u'
		&& givenString[i] != 'i' && givenString[i] != 'o' && givenString[i] != 'p' && givenString[i] != 'a' && givenString[i] != 's' && givenString[i] != 'd' && givenString[i] != 'f'
		 && givenString[i] != 'g' && givenString[i] != 'h' && givenString[i] != 'j' && givenString[i] != 'k' && givenString[i] != 'l' && givenString[i] != 'z' && givenString[i] != 'x'
		  && givenString[i] != 'c' && givenString[i] != 'v' && givenString[i] != 'b' && givenString[i] != 'n' && givenString[i] != 'm' && givenString[i] != ',' && givenString[i] != '.'
		   && givenString[i] != '!' && givenString[i] != '?' && givenString[i] != 'ę' && givenString[i] != 'ó' && givenString[i] != 'ą' && givenString[i] != 'ś' && givenString[i] != 'ł'
		    && givenString[i] != 'ż' && givenString[i] != 'ź' && givenString[i] != 'ć' && givenString[i] != 'ń' && givenString[i] != 'Ę' && givenString[i] != 'Ó' && givenString[i] != 'Ą'
			 && givenString[i] != 'Ś' && givenString[i] != 'Ł' && givenString[i] != 'Ż' && givenString[i] != 'Ź' && givenString[i] != 'Ć' && givenString[i] != 'Ń' && givenString[i] != ' '
			  && givenString[i] != '1' && givenString[i] != '2' && givenString[i] != '3' && givenString[i] != '4' && givenString[i] != '5' && givenString[i] != '6' && givenString[i] != '7'
			   && givenString[i] != '8' && givenString[i] != '9' && givenString[i] != '0' && givenString[i] != '-' && givenString[i] != '(' && givenString[i] != ')' && givenString[i] != '['
			    && givenString[i] != ']')
	    {
	        tak = 0;
		}
	}
	if(tak != 1) return 0;
	else return 1;
}