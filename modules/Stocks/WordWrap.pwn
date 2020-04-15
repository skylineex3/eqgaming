stock WordWrap(givenString[128], spaces) // By Mario
{
	new editingString[128], spaceCounter = 0;
	memcpy(editingString, givenString, 0, 128 * 4);

	// Zrób pêtlê na ka¿dy bit
	for (new i = 0; editingString[i] != 0; i++)
	{
	    // SprawdŸ czy po przecinku lub kropce jest spacja - jeœli nie, dodaj j¹
	    if(editingString[i] == ',' || editingString[i] == '.')
	    {
			if(editingString[i+1] != ' ') strins(editingString, " ", i + 1);
		}

		// Nalicz spacje
	    if(editingString[i] == ' ' && editingString[i+1] != ' ') spaceCounter++;

		// Jeœli naliczy³ wskazan¹ iloœæ spacji, przenieœ do nastêpnej linijki
	    if(spaceCounter >= spaces)
		{
			editingString[i] = '\n';
			spaceCounter = 0;
		}
	}
	return editingString;
}
