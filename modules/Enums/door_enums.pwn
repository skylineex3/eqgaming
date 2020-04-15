enum ENUM_DOORS
{
	samp_id,
	Type,
	//Model pickupa
	Model,
	//Pozycja wej�ciowa
	Float:EnterX,
	Float:EnterY,
	Float:EnterZ,
	Float:EnterA,
	EnterVW,
	EnterInterior,
	//Pozycja wyj�ciowa
	Float:ExitX,
	Float:ExitY,
	Float:ExitZ,
	Float:ExitA,
	ExitVW,
	ExitInterior,
	//Informacje
	UID,
	Owner,
	Locked,
	Name[24]
};

new Doors[MAX_DOORS][ENUM_DOORS];
