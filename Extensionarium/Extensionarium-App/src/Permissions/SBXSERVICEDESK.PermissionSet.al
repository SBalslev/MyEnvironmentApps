permissionset 50702 SBX_SERVICE_DESK
{
    Assignable = true;
    Permissions =
        tabledata "SBX Service Request" = RMID,
        tabledata "SBX Service Request Category" = RMID,
        tabledata "SBX Property" = R,
        tabledata "SBX Unit" = R,
        tabledata "SBX Lease" = R,
        tabledata "SBX Lease Amendment History" = R;
}
