forward Log(type[], text[]);
public Log(type[], text[])
{
	new string[500];
	format(string, sizeof(string), "[%s] %s", type, text);

	new DB_Query[500];
	format(DB_Query, sizeof(DB_Query), "INSERT INTO `rp_logs` (`log_text`) VALUES ('%s')", string);
	mysql_query(DB_Query);
	return 1;
}
