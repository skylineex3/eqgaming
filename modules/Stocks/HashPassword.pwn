stock HashPassword(string[], salt[])
{
    new string2[96];
 	format(string2, sizeof(string2), "%s%s", MD5_Hash(salt), MD5_Hash(string));
 	for (new i; i < sizeof(string2); i++) string2[i] = tolower(string2[i]);
    format(string2, sizeof(string2), "%s", MD5_Hash(string2));
    return string2;
}
