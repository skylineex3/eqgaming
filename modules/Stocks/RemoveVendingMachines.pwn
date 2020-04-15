stock RemoveVendingMachines(playerid)
{
    // Remove 24/7 machines
    RemoveBuildingForPlayer(playerid, 1776, -33.8750, -186.7656, 1003.6328, 0.25);
    RemoveBuildingForPlayer(playerid, 1775, -32.4453, -186.6953, 1003.6328, 0.25);

    // Remove all other machines
    for(new i = 0; i < 44; i++)
    {
        RemoveBuildingForPlayer(playerid, 955, VMachines[i][0], VMachines[i][1], VMachines[i][2], 0.50);
        RemoveBuildingForPlayer(playerid, 956, VMachines[i][0], VMachines[i][1], VMachines[i][2], 0.50);
    }
    return 1;
}
