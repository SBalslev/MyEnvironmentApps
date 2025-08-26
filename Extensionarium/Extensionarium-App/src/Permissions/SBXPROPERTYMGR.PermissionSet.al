permissionset 50700 SBX_PROPERTY_MGR
{
    Assignable = true;
    Permissions =
        tabledata "SBX Property" = RMID,
        tabledata "SBX Unit" = RMID,
        tabledata "SBX Lease" = RMID,
        tabledata "SBX Lease Amendment History" = R,
        tabledata "SBX Lease Charge Template" = RMID,
        tabledata "SBX Recurring Charge Line" = RMID,
        tabledata "SBX Service Request" = R,
        tabledata "SBX Service Request Category" = R,
        tabledata "SBX Deposit Ledger Entry" = R,
        tabledata "SBX Extensionarium Setup" = R,
        tabledata "SBX Property Mgr Cue" = R;
}
