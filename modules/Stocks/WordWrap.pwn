stock WordWrap(givenString[128], spaces) // By Mario
{
	new editingString[128], spaceCounter = 0;
	memcpy(editingString, givenString, 0, 128 * 4);

	// Zr�b p�tl� na ka�dy bit
	for (new i = 0; editingString[i] != 0; i++)
	{
	    // Sprawd� czy po przecinku lub kropce jest spacja - je�li nie, dodaj j�
	    if(editingString[i] == ',' || editingString[i] == '.')
	    {
			if(editingString[i+1] != ' ') strins(editingString, " ", i + 1);
		}

		// Nalicz spacje
	    if(editingString[i] == ' ' && editingString[i+1] != ' ') spaceCounter++;

		// Je�li naliczy� wskazan� ilo�� spacji, przenie� do nast�pnej linijki
	    if(spaceCounter >= spaces)
		{
			editingString[i] = '\n';
			spaceCounter = 0;
		}
	}
	return editingString;
}
